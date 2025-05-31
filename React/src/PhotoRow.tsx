import { ReactNode } from "react";
import getPhoto from "./client"

interface PhotoRow {
    width?: number;
}

type PhotoProp = {
    width: number,
    height: number,
    src?: string,
};



export default function PhotoRow({width} : PhotoRow) {
    const photos : PhotoProp[] = [];

    console.log("XCVKOSXHCVOJHXVKJXC")

    photos.push({width: 100, height: 100, src: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Ambersweet_oranges.jpg/1200px-Ambersweet_oranges.jpg"})
    return (
        <div>
            <img src={""}></img>
            {
                photos.map( ({width, height, src}, i) => (
                    <img key={i} width={width} height={height} src={src}></img>
                ))
            }
        </div>
    );
}