import crud, database, models
import cv2

def show_img(path : str) -> None:
    img = cv2.imread(path)
    img = cv2.resize(img, (600, 400))
    cv2.imshow("image", img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

def main():
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
    

if __name__ == '__main__':
    main()

