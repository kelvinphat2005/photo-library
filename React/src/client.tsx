import axios from 'axios';

const SERVER_API = "http://localhost:8000";

export default async function getPhoto(id : number) {
    try {
        const { data: blob } = await axios.get<Blob>(
            `http://localhost:8000/photos/${id}`,
            { responseType: "blob" }
        );
        console.log(URL.createObjectURL(blob))
        // turn the blob into url
        return URL.createObjectURL(blob); 
    } catch (error) {
        return "";
    }
}