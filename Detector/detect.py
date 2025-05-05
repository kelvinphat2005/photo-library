from torchvision import transforms
import torch
import os
import cv2
import PIL.Image
from ultralytics import YOLO
import open_clip, torch, cv2, numpy as np, hdbscan, glob
import numpy as np
import pickle, os
import numpy as np, matplotlib.pyplot as plt
from sklearn.decomposition import PCA
import pathlib

model = YOLO("./scripts/detector/model/yolov8x6_animeface.pt")  

CACHE_FILE = "./scripts/detector/crop_cache.pkl"

def detect_batch(folder="./photos"):
	if os.path.exists(CACHE_FILE):
		with open(CACHE_FILE, "rb") as f:
			return pickle.load(f)
		
	crops = []
	for path in pathlib.Path(folder).iterdir():
		if path.is_file():
			crops.extend(detect(str(path)))
	
	with open(CACHE_FILE, "wb") as f:
		pickle.dump(crops, f)                # << save list to disk
	return crops

def test():
	crops = detect_batch()
	
	for c in crops:
		cv2.imshow("crop", c)
		cv2.waitKey(0)

	embed(crops)

def main():
	crops = []
	img = cv2.imread("./photos/test.jpg")
	crops = detect(img)
	
	for c in crops:
		cv2.imshow("crop", c)
		cv2.waitKey(0)

def embed(imgs):
	model, _, preprocess = open_clip.create_model_and_transforms(
        'ViT-L-14', pretrained=None)
	
	model.eval()

	ckpt = './scripts/detector/model/DanbooruCLIP.bin'
	open_clip.load_checkpoint(model, ckpt, strict=False)
	
	embeds = []
	for img in imgs:
		img = PIL.Image.fromarray(img)
		img = preprocess(img).unsqueeze(0)
		with torch.no_grad():
			v = model.encode_image(img).cpu().numpy()  
		embeds.append(v[0])
	X = np.vstack(embeds) 

	clusterer = hdbscan.HDBSCAN(metric='euclidean',   # euclidean on unit-sphere ≈ cosine
                            min_cluster_size=4,
                            min_samples=1,
                            cluster_selection_method='eom')
	labels = clusterer.fit_predict(X)

	pts_2d = PCA(n_components=2, random_state=0).fit_transform(X)   # only for viz

	plt.figure(figsize=(8, 6))
	plt.scatter(pts_2d[:, 0], pts_2d[:, 1], c=labels, s=14, alpha=0.8)
	plt.title("PCA projection of CLIP embeddings (colour = HDBSCAN cluster)")
	plt.xlabel("PC-1"); plt.ylabel("PC-2")
	plt.tight_layout()
	plt.show()
	pass


def detect(img):
	crops = []
	# if img is a string, load the image
	if isinstance(img, str):
		# check if the file exists
		if not os.path.isfile(img):
			raise FileNotFoundError(f"File {img} not found.")
		# read the image
		img = cv2.imread(img)

	# do nothing if the image is already there
	# put image through the model
	result = model.predict(img, save=True, conf=0.3, iou=0.5)[0] # we only want the first result, since one image is passed

	print(result)
	for box in result.boxes.xyxy: # get the boxes in an (x,y) x (x,y) format
		x1, y1, x2, y2 = box.squeeze().cpu().round().int().tolist()
		print(box)

		# extend crops
		H, W = img.shape[:2]
		w,  h  = x2 - x1,  y2 - y1  
		margin = 0.25                        # 25 % on each side
		x0 = max(0,      x1 - w * margin)             # left   expansion
		y0 = max(0,      y1 - h * margin)             # top    expansion
		x3 = min(W,      x2 + w * margin)             # right  expansion
		y3 = min(H,      y2 + h * margin)
		crop = img[int(y0):int(y3), int(x0):int(x3)]
		crops.append(crop)
	

	return crops



if __name__ == "__main__":
	test()