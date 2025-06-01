import { ReactNode } from "react";
import getPhoto from "./client"

interface PhotoRow {
    maxImages?: number;
}

type PhotoTile = {
    width: number,
    height: number,
    src?: string,
};

const useTestPhotos : boolean = true;

export default function PhotoRow({maxImages} : PhotoRow) {
    const photos : PhotoTile[] = [];

    if (useTestPhotos){ 
        loadTestPhotos(photos);
    }

    return (
        <div className="flex flex-auto flex-start">
            {
                photos.map( ({width, height, src}, i) => (
                    <div >
                        <img className="min-h-56 max-h-56 px-0.5 py-0.5 object-cover"key={i} src={src}></img>
                    </div>
                ))
            }
        </div>
    );
}

function loadTestPhotos(photos : PhotoTile[]) {
    photos.push({width: 1200, height: 1353, src: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Ambersweet_oranges.jpg/1200px-Ambersweet_oranges.jpg"})
    photos.push({width: 740, height: 503, src: "https://img.freepik.com/premium-photo/food-drinks-fruits-coffee_1126632-354.jpg?semt=ais_hybrid&w=740"})
    photos.push({width: 740, height: 493, src: "https://img.freepik.com/free-photo/colorful-fruits-tasty-fresh-ripe-juicy-white-desk_179666-169.jpg?semt=ais_hybrid&w=740"})
    photos.push({width: 2048, height: 1536, src: "https://images.pexels.com/photos/70746/strawberries-red-fruit-royalty-free-70746.jpeg?cs=srgb&dl=pexels-pixabay-70746.jpg&fm=jpg"})
    photos.push({width: 551, height: 360, src: "https://t4.ftcdn.net/jpg/00/65/70/65/360_F_65706597_uNm2SwlPIuNUDuMwo6stBd81e25Y8K8s.jpg"})
    photos.push({width: 1280, height: 759, src: "https://cdn.pixabay.com/photo/2015/03/30/19/36/fruit-700006_1280.jpg"})
    photos.push({width: 1280, height: 848, src: "https://cdn.pixabay.com/photo/2019/10/28/16/03/still-life-4584802_1280.jpg"})
}