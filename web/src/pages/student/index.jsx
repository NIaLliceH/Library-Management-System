import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import classNames from 'classnames/bind';
import styles from './student.module.css';

const clx = classNames.bind(styles);

const Student = () => {
  const [students, setStudents] = useState([

  ]);

  const [DashBoardData, setData] = useState([]);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(true);
  const [search, setsearch] = useState(null);
  const [tempdata, settempdata] = useState([]);

  const filterData = () => {
    const removeVietnameseTones = (str) => {
      return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/đ/g, "d").replace(/Đ/g, "D");
    };
    const normalizedSearch = removeVietnameseTones(search).toLowerCase();
    const filteredData = tempdata.filter(item =>
      removeVietnameseTones(item.name).toLowerCase().includes(normalizedSearch) ||
      item.email.toLowerCase().includes(normalizedSearch)
    );
    setStudents(filteredData);
  }

  useEffect(() => {
    const fetchData = async (e) => {
      try {
        const response = await fetch("http://localhost:3001/api/authen/allstudent", {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        });

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const result = await response.json();
        const formattedStudents = result.data.map(student => {
          const formattedJoinDate = new Date(student.joinDate).toISOString().split('T')[0];
          return {
            ...student,
            joinDate: formattedJoinDate,
          };
        });

        setStudents(formattedStudents);
        settempdata(formattedStudents)

      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);




  const navigate = useNavigate();

  const handleNavigate = (id, email, type) => {
    navigate(`/ticket/${id}/${email}/${type}`);
  };

  return (
    <div className={clx('container')}>
      <div className={clx('title')}>
        <div>Danh sách học sinh</div>
      </div>

      <div className={clx('search-box')}>
        <input
          type="text"
          className={clx('search-input')}
          placeholder="Tìm kiếm..."
          onChange={(e)=>{setsearch(e.target.value)}}
        />
        <button className={clx('search-button')} onClick={filterData}>Tìm kiếm</button>
      </div>

      <div>
        <table className={clx('table-container')}>
          <thead>
            <tr>
              <th>STT</th>
              <th>Email</th>
              <th>Name</th>
              <th>Birthday</th>
              <th>Faculty</th>
              <th>Join Date</th>
              <th>Hold tickets</th>
              <th>Borrow tickets</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {students.map((student, index) => (
              <tr key={student.email}>
                <td>{index + 1}</td>
                <td>{student.email}</td>
                <td>{student.name}</td>
                <td>{student.dob}</td>
                <td>{student.faculty}</td>
                <td>{student.joinDate}</td>
                <td>
                  <button
                    className={clx('link')}
                    onClick={() => handleNavigate(student.userId, student.email, 'hold')}
                  >
                    {student.numHold}
                  </button>
                </td>
                <td>
                  <button
                    className={clx('link')}
                    onClick={() => handleNavigate(student.userId, student.email, 'borrow')}
                  >
                    {student.numBorrow}
                  </button>
                </td>
                <td style={{backgroundColor}}>{student.accountStatus == 'on' ? 'active': 'banned'}</td>
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
      </div>
    </div>
  );
};

export default Student;