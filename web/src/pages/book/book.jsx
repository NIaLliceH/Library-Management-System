import React, { useState, useEffect } from 'react';
import classNames from 'classnames/bind';
import styles from './book.module.css';
import { useNavigate } from 'react-router-dom';

const clx = classNames.bind(styles);

const Book = () => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [books, setBooks] = useState([]);
  const [tempbooks, settempBooks] = useState([]);


  useEffect(() => {
    const fetchData = async (e) => {
      try {
        const response = await fetch("http://localhost:3001/api/books", {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        });

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const result = await response.json();
        setBooks(result.data);
        settempBooks(result.data);
      } catch (err) {
        // setError(err.message);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  const handleDelete = async (id) => {

    const isConfirmed = window.confirm("Bạn có chắc chắn muốn xóa sách này?");

    if (isConfirmed) {
      try {
        const response = await fetch("http://localhost:3001/api/books/" + id, {
          method: "DELETE",
          headers: {
            "Content-Type": "application/json",
          },
        });

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        setBooks(books.filter((book) => book.bookId !== id));
      } catch (err) {
        console.error('Delete failed:', err.message);
      }
    } else {
      console.log("Xóa bị hủy bỏ");
    }
  };

  const handleSearch = async () => {
    if (search == "")
      setBooks(tempbooks)
    else
      try {
        const response = await fetch(`http://localhost:3001/api/books/search/?name=${encodeURIComponent(search)}`, {
          method: "GET",
          headers: {
            "Content-Type": "application/json"
          },
        });

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const result = await response.json();
        setBooks(result.data);
      } catch (err) {
        setBooks([])
      }
  }

  return (
    <div className={clx('container')}>
      <div className={clx('title')}>
        <div>Danh sách sách
        </div>
      </div>

      <div className={clx('search-box')}>
        <input
          type="text"
          className={clx('search-input')}
          placeholder="Tìm kiếm sách..."
          onChange={(e) => setSearch(e.target.value)}
        />
        <button className={clx('search-button')} onClick={handleSearch}>Tìm kiếm</button>
      </div>

      <div>
        <table className={clx('table-container')}>
          <thead>
            <tr>
              <th>STT</th>
              <th>Cover</th>
              <th>Title</th>
              <th>Author</th>
              <th>Category</th>
              <th>Available</th>
              <th></th>

            </tr>
          </thead>

          <tbody>

            {books && books.map((book, index) => (
              <tr key={book.id || `book-${index}`}>
                <td>{index + 1}</td>
                <td>
                  <img
                    src={book.imageUrl}
                    alt={book.name}
                    className={clx('book-cover')}
                    style={{ width: '90px', height: '130px', objectFit: 'cover' }}
                  />
                </td>
                <td>{book.name}</td>
                <td>{book.authors.join(', ')}</td>
                <td>{book.category}</td>

                <td>{book.noAvaiCopies}</td>
                <td>
                  <button className={clx('secondary-button-edit')} onClick={() => navigate(`/book/update/${book.bookId}`)} >Edit</button>
                  <button className={clx('secondary-button-delete')} onClick={() => handleDelete(book.bookId)} >Delete</button>
                </td>
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

      <button
        className={clx('add-button')}
        onClick={() => navigate('/book/addnew')}
      >
        +
      </button>
    </div>
  );
};

export default Book;