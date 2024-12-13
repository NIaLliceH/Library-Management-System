import { useState } from 'react'
import { Routes, Route, Navigate, Outlet} from "react-router-dom";

import Login from "./pages/Login/login";
import DefaultLayout from './components/layout/DefaultLayout';
import Student from './pages/student/index.jsx';
import Ticket from './pages/ticket/ticket.jsx';

import Book from './pages/book/book.jsx';
import Home from './pages/home/home.jsx';

import Addbook from './pages/book/addbook.jsx';
import UpdateBook from './pages/book/updatebook.jsx';

import AddBorrow from './pages/ticket/addborrow.jsx';
const isLoggedIn = ()=> {return !!localStorage.getItem('userID')}
const PrivateRoute = () => {
  const isAuthen = localStorage.getItem("userID");
  if (!isAuthen)
    return <Navigate to="/" />;
  return <Outlet />;
};


function App() {
  return (
    <Routes>
      <Route path='/' element={<Login />} />
      <Route element={<PrivateRoute/>}>
        <Route path='/student' element={<DefaultLayout><Student /></DefaultLayout>} />
        <Route path='/ticket' element={<DefaultLayout><Ticket/></DefaultLayout>} />
        <Route path='/book' element={<DefaultLayout><Book/></DefaultLayout>} />
        <Route path='/book/addnew' element={<DefaultLayout><Addbook /></DefaultLayout>} />
        <Route path='/book/update/:id' element={<DefaultLayout><UpdateBook /></DefaultLayout>} />
        <Route path='/home' element={<DefaultLayout><Home/></DefaultLayout>} />
        <Route path="/ticket/:id/:email/:type" element={<DefaultLayout><Ticket/></DefaultLayout>} />
        <Route path='/addBorrow' element={<DefaultLayout><AddBorrow/></DefaultLayout>} />
      </Route>

      <Route path="*" element={<Navigate to={isLoggedIn() ? "/home" : "/"} replace />} />

    </Routes>
  )
}

export default App;
