import React from 'react';
import classNames from 'classnames/bind';
import styles from './Sidebar.module.css';
import { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { Box } from '@mui/material';

import home from "../../assets/home.png"
import activehome from "../../assets/active_home.png"
import book from "../../assets/book.png"
import activebook from "../../assets/active_book.png"
import student from "../../assets/student.png"
import activestudent from "../../assets/active_student.png"
import ticket from "../../assets/ticket.png"
import activeticket from "../../assets/active_ticket.png"
import logo from "../../assets/logo.png"
import logout from "../../assets/logout.png"

const clx = classNames.bind(styles);

const Sidebar = () => {
  const navigate = useNavigate();
  const location = useLocation();

  const menuItems = [
    { name: "Home", path: "/home", active: activehome, inactive: home },
    { name: "Book", path: "/book", active: activebook, inactive: book },
    { name: "Student", path: "/student", active: activestudent, inactive: student },
    { name: "Ticket", path: "/ticket", active: activeticket, inactive: ticket },
  ];
  const path = location.pathname;
  return (
    <div className={clx('sidebar')}>
      <Box sx={{
        display: "flex",
        flexDirection: "row",
        alignItems: "center",
        gap: "5px",
        paddingRight: "15px",
      }}>
        <img src={logo} style={{ width: '60px', height: "auto" }} />
        <p style={{ textAlign: "center", fontSize: "24px", margin: 0, fontWeight: "bold" }}>BKLib</p>
      </Box>
      <ul className={clx('menu')}>
        {menuItems.map((item) => (
          < li key={item.path} className={clx('menu-item', { active:  path.startsWith(item.path) })}
            onClick={() => navigate(item.path)}
          >
            <img src={path.startsWith(item.path) ? item.active : item.inactive} style={{
              width: "30px", height: "30px"
            }} />
            <p style={{
              fontSize: "18px",
              fontWeight: "500",
              color: path.startsWith(item.path) ? "#1185F8" : "#ADAAAA",
            }}>{item.name}</p>
          </li>
        ))
        }

        < li className={clx('menu-item')}
          style={{
            marginTop: 'auto',
          }}
          onClick={() => {
            localStorage.removeItem('userID')
            navigate('/')
          }}
        >
          <img src={logout} style={{
            width: "30px", height: "30px"
          }} />
          <p style={{
            fontSize: "18px",
            fontWeight: "500",
          }}>Logout</p>
        </li>
      </ul>


    </div >
  );
};

export default Sidebar;
