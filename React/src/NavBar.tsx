import React from 'react';
import clsx from 'clsx'
import { useState } from 'react';
import './styling/navbar.css';
import { Link, type To } from "react-router-dom";

interface NavButton {
    to: To;
    label: string;
}

const navButtons = [
  { label: "Button 1",   to: "/1" },
  { label: "Button 2",  to: "/2" },
  { label: "Button 3", to: "/3" },
] as const;   

export default function NavBar() {
    const [open, setOpen] = useState(false);


    return (
        <nav className="bg-slate-600 p-4">
            <div className="flex items-center">
                <div className="flex flex-1 items-center gap-4">
                    <h1 className="text-2xl font-semibold text-white whitespace-nowrap">Placeholder Name</h1>
                    <input className="hidden md:block w-1/2 max-w-[1200px] px-5 py-2 rounded-full" placeholder="Search..."></input>
                </div>
                
                {/* Buttons */}
                <div className="ml-auto hidden sm:flex gap-3">
                    {navButtons.map(({ to, label }) => (
                        <NavButton to={to} label={label} />
                    ))}
                </div>
                
                {/* Dropdown Button and Keep Search */}
                <div className="flex sm:hidden ml-auto flex gap-3">
                    <button onClick={() => setOpen(i => !i)} className="rounded-full text-white bg-blue-500 hover:bg-blue-800 px-5 py-2">Dropdown</button>
                </div>
            </div>
            {/* Dropdown Menu */}
            <div className={clsx("block sm:hidden", open ? "block" : "hidden")}>
                <ul className="pt-2">
                    {navButtons.map(({to, label}) => (
                        <li className="py-2"><Link className="text-white font-semibold" to={to}>{label}</Link></li>
                    ))}
                </ul>
            </div>
        </nav>
    );
}

function NavButton({ to, label }: NavButton) {
  return (
    <Link
      to={to}
      className="inline-block rounded-full bg-blue-500 hover:bg-blue-800 px-5 py-2 text-white whitespace-nowrap">
      {label}
    </Link>
  );
}