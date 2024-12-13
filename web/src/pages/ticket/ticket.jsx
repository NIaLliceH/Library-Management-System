import React, { useState, useEffect } from 'react';
import classNames from 'classnames/bind';
import styles from './ticket.module.css';
import { useLocation, useNavigate } from 'react-router-dom';

import {  Box, Dialog, DialogTitle,} from '@mui/material';


const clx = classNames.bind(styles);

const TicketPage = () => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [activeItem, setActiveItem] = useState(null);
  const [search, setsearch] = useState(null);
  const location = useLocation();
  const pathname = location.pathname;
  const [toggleTable, setToggleTable] = useState(null);

  const [successModalOpen, setSuccessModalOpen] = useState(false);

  const idx = pathname.split('/')[2];
  const email = pathname.split('/')[3];
  let type = pathname.split('/')[4] || null;


  const [data, setData] = useState([]);
  const [tempdata, settempdata] = useState([]);

  const handleCloseModal = () => {
    setSuccessModalOpen(false);
  }


  const filterData = () => {
    const removeVietnameseTones = (str) => {
      return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/đ/g, "d").replace(/Đ/g, "D");
    };
    const normalizedSearch = removeVietnameseTones(search).toLowerCase();
    const filteredData = tempdata.filter(item =>
      removeVietnameseTones(item.title).toLowerCase().includes(normalizedSearch)
    );
    setData(filteredData);
  }
  useEffect(() => {
    const fetchData = async (e) => {
      let isToggleTable = (toggleTable == null) ? ((type === "hold" || type === null) ? true : false) : toggleTable;

      if (isToggleTable) {
        setToggleTable(true);
        setActiveItem("hold");
      } else {
        setToggleTable(false);
        setActiveItem("borrow");
      }

      try {
        let response;
        if (isToggleTable) {
          if (idx) {
            response = await fetch(`http://localhost:3001/api/${idx}/hold`, {
              method: "GET",
              headers: {
                "Content-Type": "application/json",
              },
            });
          } else {
            response = await fetch("http://localhost:3001/api/hold", {
              method: "GET",
              headers: {
                "Content-Type": "application/json",
              },
            });
          }
        } else {
          if (idx) {
            response = await fetch(`http://localhost:3001/api/${idx}/borrow`, {
              method: "GET",
              headers: {
                "Content-Type": "application/json",
              },
            });
          } else {
            response = await fetch("http://localhost:3001/api/borrow", {
              method: "GET",
              headers: {
                "Content-Type": "application/json",
              },
            });
          }
        }

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const result = await response.json();

        const formattedTickets = result.map(ticket => {
          const formattedcreatedDate = new Date(ticket.createdDate).toISOString().split('T')[0];
          const formattedexpiredDate = new Date(ticket.expiredDate).toISOString().split('T')[0];

          return {
            ...ticket,
            createdDate: formattedcreatedDate,
            expiredDate: formattedexpiredDate,
          };
        });

        setData(formattedTickets);
        settempdata(formattedTickets);
      } catch (err) {
        // setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [idx, toggleTable]);


  const handleReturn = (id, index) => {
    const returnBook = async (e) => {
      try {
        const response = await fetch(`http://localhost:3001/api/returnedBook/` + id, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
        });

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const result = await response.json();
        setSuccessModalOpen(true);
        const updatedData = [...data]; 
        updatedData[index].status = 'returned';
        setData(updatedData);
      } catch (err) {

      } finally {
      }
    };

    returnBook();
  }


  return (
    <div className={clx('container')}>
      <div className={clx('title')}>
        <div>Danh sách vé {idx ? `của ${email}` : ''}</div>
      </div>

      <div className={clx('toggle')}>
        <button onClick={() => { setToggleTable(true); setActiveItem('hold'); }}
          className={clx('toggle-button', { active: activeItem === 'hold' })}
        >
          Hold tickets
        </button>

        <button onClick={() => { setToggleTable(false); setActiveItem('borrow'); }}
          className={clx('toggle-button', { active: activeItem === 'borrow' })}
        >
          Borrow tickets
        </button>
      </div>
      <div className={clx('search-box')}>
        <input type="text" className={clx('search-input')} placeholder="Tìm kiếm..." onChange={(e) => { setsearch(e.target.value) }} />
        <button className={clx('search-button')} onClick={filterData}>Tìm kiếm</button>
      </div>

      <div>
        <table className={clx('table-container')}>
          <thead>
            <tr>
              <th>ID</th>
              <th>Title</th>
              <th>Author</th>

              <th>Created date</th>
              <th>Expired date</th>
              <th>Day left</th>
              <th>Status</th>

              {!toggleTable && <th></th>}

            </tr>
          </thead>
          <tbody>

            {data && data.map((item, index) => (
              <tr key={item.id || `student-${index}`}>
                <td>{index + 1}</td>
                <td>{item.title}</td>
                <td>{item.author}</td>
                <td>{item.createdDate}</td>
                <td>{item.expiredDate}</td>
                <td>{item.dayLeft}</td>
                <td
                  style={{
                    color: item.status === 'valid' ? '#35f054'
                      : item.status === 'invalid' ? '#f07171'
                        : item.status === 'borrowing' ? '#03b6fc'
                          : '#969696', fontWeight: 'bold'
                  }}
                >
                  {item.status}
                </td>
                {!toggleTable && item.status === 'borrowing' &&
                  <td>
                    <button
                      className={clx('prev')}
                      onClick={() => handleReturn(item.borrowTicket_ID, index)}
                    >Return</button>
                  </td>
                }

              </tr>
            ))}
          </tbody>
        </table>

        {loading && (
          <div className={clx('spinner-container')}>
            <div className={clx('spinner')}></div>
          </div>
        )}

        <div className={clx('pagination')}>
          <div className={clx('buttons')}>
            <button className={clx('prev')}>&lt;&lt; Trước</button>
            <button className={clx('next')}>Sau &gt;&gt;</button>
          </div>
        </div>

        {!toggleTable &&
          <button
            className={clx('add-button')}
            onClick={() => navigate('/addBorrow')}
          >
            +
          </button>
        }

        <Dialog open={successModalOpen} onClose={handleCloseModal} >
          <Box
            sx={{
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              justifyContent: "center",
              p: 3,
            }}
          >
            <DialogTitle sx={{ textAlign: "center", fontSize: "30px", padding: "20px", color: "#38baba" }}>Trả sách thành công</DialogTitle>
          </Box>
        </Dialog>

      </div>
    </div>
  );
};

export default TicketPage;
