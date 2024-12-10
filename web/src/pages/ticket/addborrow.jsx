import React, { useEffect, useState } from 'react';
import {
    Box, TextField, Select, MenuItem, FormControl, Button, Typography, Stack, Dialog, DialogTitle,
} from '@mui/material';

const AddBorrow = () => {
    const [books, setBooks] = useState([]);
    const [copies, setCopies] = useState([]);
    const [users, setUsers] = useState([]);
    const [selectedBook, setSelectedBook] = useState('');
    const [selectedCopy, setSelectedCopy] = useState('');
    const [selectedUser, setSelectedUser] = useState('');
    const [successModalOpen, setSuccessModalOpen] = useState(false);
    const handleCloseModal = () => {
        setSuccessModalOpen(false);
    }
    useEffect(() => {
        const fetchData = async (e) => {
            // try {
            // const response = await fetch("http://localhost:3001/api/???", {
            //     method: "GET",
            //     headers: {
            //         "Content-Type": "application/json",
            //     },
            // });

            //     if (!response.ok) {
            //         throw new Error(`HTTP error! status: ${response.status}`);
            //     }
            //     const result = await response.json();


            // } catch (err) {
            //     setError(err.message);
            // }

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

            } catch (err) {
                setError(err.message);
            }

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
                const formattedStudents = result.data.map(student => ({
                    id: student.userId,
                    name: student.name,
                    email: student.email,
                }));
                console.log(formattedStudents);
                setUsers(formattedStudents);

            } catch (err) {
                setError(err.message);
            }
        };

        fetchData();
    }, []);

    useEffect(() => {
        const getCopies = async (e) => {
            try {
                const response = await fetch("http://localhost:3001/api/admin/copybooks/" + selectedBook, {
                    method: "GET",
                    headers: {
                        "Content-Type": "application/json",
                    },
                });

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                const result = await response.json();
                setCopies(result.data);

            } catch (err) {
                setError(err.message);
            }
        };
        getCopies();
    }, [selectedBook]);

    const handleAddBorrow = () => {
        if (selectedBook && selectedCopy && selectedUser) {
            const userID = localStorage.getItem('userID');
            const fetchData = async () => {
                try {

                    if (!userID) {
                        throw new Error('User ID not found in localStorage');
                    }

                    const response = await fetch(`http://localhost:3001/api/${selectedUser}/borrow`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            ID_copy: selectedCopy,
                            ID_admin: userID,
                        }),

                    });

                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    const data = await response.json();
                    setSuccessModalOpen(true);
                } catch (error) {
                    console.error('Fetch error:', error);
                }
            };
            fetchData();
        }

    };

    return (
        <Box sx={{ padding: '20px 10% ' }}>
            <Typography variant="h4" gutterBottom sx={{ fontWeight: 'bold', textAlign: 'left', padding: '10px 0 ' }} >
                Add borrow ticket
            </Typography>
            <form>
                <Stack spacing={3}>
                    <Box>
                        <Typography variant="h6" sx={{ fontWeight: "bold" }}>Book:</Typography>
                        <FormControl fullWidth>
                            <Select
                                sx={{ backgroundColor: '#ffffff', height: "50px" }}
                                value={selectedBook}
                                onChange={(e) => setSelectedBook(e.target.value)}
                            >
                                {books.map((book) => (
                                    <MenuItem key={book.bookId} value={book.bookId}>
                                        {book.name}
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                    </Box>
                    <Box>
                        <Typography variant="h6" sx={{ fontWeight: "bold" }}>Copy:</Typography>
                        <FormControl fullWidth>
                            <Select
                                sx={{ backgroundColor: '#ffffff', height: "50px", }}
                                value={selectedCopy}
                                onChange={(e) => setSelectedCopy(e.target.value)}
                            >
                                {copies.map((copy) => (
                                    <MenuItem key={copy} value={copy}>
                                        {copy}
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                    </Box>
                    <Box>
                        <Typography variant="h6" sx={{ fontWeight: "bold" }}>Học sinh:</Typography>
                        <FormControl fullWidth>
                            <Select
                                sx={{ backgroundColor: '#ffffff', height: "50px" }}
                                value={selectedUser}
                                onChange={(e) => setSelectedUser(e.target.value)}
                            >
                                {users.map((user) => (
                                    <MenuItem key={user.id} value={user.id}>
                                        {`${user.name} - ${user.email}`}
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                    </Box>
                    <Box sx={{ textAlign: 'center' }}>
                        <Button variant="contained" sx={{ backgroundColor: "#38baba" }} onClick={handleAddBorrow}>
                            Add Ticket
                        </Button>
                    </Box>
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
                            <DialogTitle sx={{ textAlign: "center", fontSize: "30px", padding: "20px", color: "#38baba" }}>Tạo vé thành công</DialogTitle>
                        </Box>
                    </Dialog>
                </Stack>
            </form>
        </Box>
    );

};

export default AddBorrow;
