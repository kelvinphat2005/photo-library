import crud, database, models
import requests, pathlib, json
import cv2
import pathlib

def show_img(path : str) -> None:
    img = cv2.imread(path)
    img = cv2.resize(img, (600, 400))
    cv2.imshow("image", img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

def regular_data_base_test():
    print("DATABASE PATH:", database.DATABASE_PATH)
    print("SAVED PHOTOS PATH", database.PHOTO_FOLDER_PATH)

    database.init_db()

    conn = database.get_conn()

    crud.add_photo(conn, "C:/Users/kelvi/OneDrive/Documents/Code/python db server/attempt1/testphotos/Gr22_FOXsAEG9mF.jpg")
    crud.add_photo(conn, "C:/Users/kelvi/OneDrive/Documents/Code/python db server/attempt1/testphotos/GryrtEmXsAEDxEd.jpg")
    p = crud.get_photo_from_id(conn, 1)

    print(p)
    
    show_img(p.path)
    p = crud.get_photo_from_id(conn, 2)
    show_img(p.path)

    p = cv2.imread("C:/Users/kelvi/OneDrive/Documents/Code/python db server/attempt1/testphotos/test1.png")
    crud.add_photo_img(conn, p, "png")

def server_test():
    img_request = requests.get("http://127.0.0.1:8000/photos/1")
    # get file bytes, write to jpg
    if img_request.status_code == 200:
        with open("./temp.jpg", 'wb') as f:
            for chunk in img_request.iter_content(1024):
                f.write(chunk)

    with open("C:/Users/kelvi/OneDrive/Documents/Code/python db server/attempt1/testphotos/test1.png", "rb") as img:
        requests.post("http://127.0.0.1:8000/upload", files={"photo": img} )

    with open("C:/Users/kelvi/OneDrive/Documents/Code/python db server/attempt1/testphotos/test2.png", "rb") as img:
        requests.post("http://127.0.0.1:8000/upload", files={"photo": img} )
    

def main():
    #regular_data_base_test()
    server_test()
    

if __name__ == '__main__':
    main()

