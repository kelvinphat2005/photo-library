import React from 'react';
import logo from './logo.svg';
import './styling/App.css';
import NavBar from './NavBar'
import PhotoRow from './PhotoRow'

let currPhotoIndex = 0;

function App() {
  return (
    <>
    <NavBar/>
    <PhotoRow/>
    </> 
  );
}

export default App;
