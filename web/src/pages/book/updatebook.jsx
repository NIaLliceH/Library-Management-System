import React, { useEffect, useState } from 'react';
import { Box, TextField, Select, MenuItem, FormControl, Button, Typography, Grid, Dialog, DialogTitle, } from '@mui/material';
import { useParams } from 'react-router-dom';

import axiosInstance from '../../Axios';
import checked from '../../assets/checked.png';
import close from '../../assets/close.png';
import add from '../../assets/add.png';
const UpdateBook = () => {
    //ID book
    const { id } = useParams();

    const [title, settitle] = useState("");
    const [category, setcategory] = useState("");
    const [numcopies, setnumcopies] = useState(0);
    const [numclonecopies, setnumclonecopies] = useState(0);
    const [copies, setcopies] = useState([]);
    const [clonecopies, setclonecopies] = useState([]);
    const [pages, setpages] = useState("");
    const [publisher, setpublisher] = useState("");
    const [description, setdescription] = useState("");
    const [image, setimage] = useState("");
    const [author, setauthor] = useState([]);
    const [authorstring, setauthorstring] = useState([]);
    const [edition, setedition] = useState("");

    const [allcategories, setallcategories] = useState([]);
    const [deletecopies, setdeletecopies] = useState([]);

    const [successModalOpen, setSuccessModalOpen] = useState(false);
    const handleCloseModal = () => {
        setSuccessModalOpen(false);
    }
    // thay doi copies
    const handleInputChange = (index, field, value) => {
        const updatedCopies = [...copies];
        updatedCopies[index][field] = value;
        setcopies(updatedCopies);
    };
    // thay doi clone copies
    const handleInputChangeClone = (index, field, value) => {
        const updatedCopies = [...clonecopies];
        updatedCopies[index][field] = value;
        setclonecopies(updatedCopies);
    };
    //xoa copies
    const handleRemoveCopy = (index) => {
        if (copies[index]?.copyId)
            setdeletecopies((prev) => [...prev, copies[index].copyId])
        const updatedCopies = copies.filter((_, i) => i !== index); // Loại bỏ phần tử tại index
        setcopies(updatedCopies);
        setnumcopies(updatedCopies.length)
    };
    //xoa clone copies
    const handleRemoveCopyClone = (index) => {
        const updatedCopies = clonecopies.filter((_, i) => i !== index); // Loại bỏ phần tử tại index
        setclonecopies(updatedCopies);
        setnumclonecopies(updatedCopies.length)
    };

    // kiem tra cac truong du lieu
    const [errors, setErrors] = useState({});
    const validateForm = () => {
        const newErrors = {};

        if (!title.trim()) newErrors.title = "Yêu cầu tiêu đề.";
        if (!publisher.trim()) newErrors.publisher = "Yêu cầu nhà xuất bản";
        if (!category.trim()) newErrors.category = "Yêu cầu thể loại.";
        if (numcopies <= 0 && numclonecopies <= 0) newErrors.numcopies = "Số lượng bản sao > 0.";
        if (parseInt(pages) <= 0) newErrors.pages = "Số lượng trang > 0.";
        // if (!image.trim()) newErrors.image = "Image URL is required.";

        setErrors(newErrors);

        return Object.keys(newErrors).length === 0;
    };
    // lay thong tin tu api
    const fecthInformation = async () => {
        const res = ((await axiosInstance.get(`books/${id}`,)).data.data);

        settitle(res.name || "")
        setcategory(res.category)
        setpages(res.noPages || 0)
        setcopies(res.copies || 0)
        setnumcopies((res.copies).length)
        setpublisher(res.publisher || "")
        setimage(res.imageUrl || "")
        setdescription(res.description)
        setauthor(res.authors || "")
        setauthorstring(res.authors.join(", "))
        setedition(res.edition || "")

        setclonecopies([])
        setnumclonecopies(0)
        setdeletecopies([])
    }
    useEffect(() => {
        const fecthCatories = async () => {
            const res = await axiosInstance.get('books/categories');
            setallcategories(res.data.data);
        }
        fecthCatories()
        fecthInformation()
    }, [])
    // update thong tin
    const handleUpdateBook = async () => {
        if (!validateForm()) return;

        console.log({
            name: title,
            authors: author,
            noPages: parseInt(pages),
            category: category,
            publisher: publisher,
            description: description,
            noCopies: numcopies,
            nocloneCopies: numclonecopies,
            edition: edition,
            imageUrl: image,
            copies: copies,
            copyIDS: deletecopies,
            clonecopies: clonecopies
        })
        const res = await axiosInstance.put(`books/${id}`, {
            name: title,
            authors: author,
            NoPages: parseInt(pages),
            category: category,
            Publisher: publisher,
            Description: description,
            NoValidCopies: numcopies,
            edition: edition,
            imageUrl: image,
            copies: clonecopies,
        }, { params: { id: id } })

        const copyUpdatePromises = copies.map((copy) =>
            axiosInstance.put(`books/${id}/copies/${copy.copyId}`, {
                shell: copy.shell,
                status: copy.status,
            })
        );
        const copyResponses = await Promise.all(copyUpdatePromises);
        const allSuccess = copyResponses.every((res) => res.status == 200);

        let response
        if (deletecopies.length)
            response = await axiosInstance.delete(`books/${id}/copies`, { data: { copyIds: deletecopies } })

        if (res.status == 200 && (!deletecopies.length || response.status == 200) && allSuccess) { 
            setSuccessModalOpen(true); 
            setdeletecopies([])
        }
    }

    return (
        <Box sx={{
            padding: "20px 10%"
        }}>
            <Typography variant="h4" gutterBottom sx={{ fontWeight: 'bold' }}>
                Cập nhập sách
            </Typography>
            <form style={{ marginLeft: '5px' }}>
                <Box mb={3} sx={{
                    display: "flex",
                    flexDirection: 'column',
                    gap: '10px'
                }}>
                    <Typography variant="h6" sx={{ fontWeight: "bold" }}>1. Thông tin sách</Typography>
                    <Box                    >
                        <Typography sx={{ fontSize: "17px" }}>Tiêu đề:</Typography>
                        <TextField fullWidth type="text" variant="outlined" onChange={(e) => {
                            settitle(e.target.value)
                            setErrors((prev) => ({ ...prev, title: "" }))
                        }}
                            sx={{
                                backgroundColor: "white",
                                "& .MuiOutlinedInput-root": {
                                    height: "40px",
                                    "& fieldset": {
                                        borderColor: errors.title ? "red" : "black", // Đổi màu viền
                                    },
                                },
                            }}
                            error={!!errors.title}
                            helperText={errors.title}
                            value={title || ""}
                        />
                    </Box>
                    <Box>
                        <Typography sx={{ fontSize: "17px" }}>Nhà Xuất bản:</Typography>
                        <TextField fullWidth type="text" variant="outlined" onChange={(e) => {
                            setpublisher(e.target.value)
                            setErrors((prev) => ({ ...prev, publisher: "" }))
                        }}
                            sx={{
                                backgroundColor: "white",
                                "& .MuiOutlinedInput-root": {
                                    height: "40px",
                                    "& fieldset": {
                                        borderColor: errors.publisher ? "red" : "black", // Đổi màu viền
                                    },
                                },
                            }}
                            error={!!errors.publisher}
                            helperText={errors.publisher}
                            value={publisher || ""}
                        />
                    </Box>

                    <Box>
                        <Typography sx={{ fontSize: "17px" }}>Tác giả:</Typography>
                        <TextField fullWidth type="text" variant="outlined" onChange={(e) => {
                            setauthorstring(e.target.value)
                            const authorsArray = e.target.value.split(",").map((au) => au.trim()).filter((au) => au !== "");
                            setauthor(authorsArray)
                        }}
                            sx={{
                                backgroundColor: "white",
                                "& .MuiOutlinedInput-root": {
                                    height: "40px",
                                    "& fieldset": {
                                        borderColor: "black", // Đổi màu viền
                                    },
                                },
                            }}
                            value={authorstring}
                        />
                    </Box>
                    <Box>
                        <Typography sx={{ fontSize: "17px" }}>Phiên bản:</Typography>
                        <TextField fullWidth type="text" variant="outlined" onChange={(e) => setedition(e.target.value)}
                            sx={{
                                backgroundColor: "white",
                                "& .MuiOutlinedInput-root": {
                                    height: "40px",
                                    "& fieldset": {
                                        borderColor: "black", // Đổi màu viền
                                    },
                                },
                            }}
                            value={edition || ""}
                        />
                    </Box>
                    <Grid container spacing={2}>
                        <Grid item xs={4}>
                            <Typography sx={{ fontSize: "17px" }}>Thể loại:</Typography>
                            <FormControl
                                fullWidth
                                sx={{
                                    backgroundColor: "white",
                                    "& .MuiOutlinedInput-root": {
                                        height: "40px",
                                        "& fieldset": {
                                            borderColor: "black", // Đổi màu viền
                                        },
                                    },
                                }}
                            >
                                <Select
                                    defaultValue=" "
                                    onChange={(e) => {
                                        setcategory(e.target.value);
                                        setErrors((prev) => ({ ...prev, category: "" })); // Xóa lỗi khi người dùng chọn giá trị
                                    }}
                                    value={category || ""}
                                >
                                    <MenuItem value=" ">Chọn</MenuItem>
                                    {allcategories.map((item) => (
                                        <MenuItem key={item} value={item}>
                                            {item}
                                        </MenuItem>
                                    ))}
                                </Select>

                                {errors.category && (
                                    <Typography sx={{ padding: "2px 10px", color: "#d32f2f", fontSize: "12px" }}>
                                        {errors.category}
                                    </Typography>
                                )}
                            </FormControl>

                        </Grid>
                        <Grid item xs={4}>
                            <Typography sx={{ fontSize: "17px" }}>Số lượng giấy:</Typography>
                            <TextField fullWidth type="number" variant="outlined" onChange={(e) => {
                                setpages(e.target.value)
                                setErrors((prev) => ({ ...prev, pages: "" }))
                            }}
                                onWheel={(e) => e.target.blur()}
                                sx={{
                                    backgroundColor: "white",
                                    "& .MuiOutlinedInput-root": {
                                        height: "40px",
                                        "& fieldset": {
                                            borderColor: errors.pages ? "red" : "black", // Đổi màu viền
                                        },
                                    },
                                }}
                                error={!!errors.pages}
                                helperText={errors.pages}
                                value={pages || ""}
                            />
                        </Grid>
                        <Grid item xs={4}>
                            <Typography sx={{ fontSize: "17px" }}>Số lượng bản sao:</Typography>
                            <Box
                                sx={{
                                    display: "flex",
                                    flexDirection: 'column',
                                    justifyItems: "center",
                                    backgroundColor: "white",
                                    border: "1px solid black",
                                    borderRadius: "4px",
                                    height: "40px",
                                    padding: "0 10px",
                                }}
                            >
                                <Box
                                    sx={{
                                        display: "flex",
                                        flex: '1',
                                        alignItems: "center",
                                        backgroundColor: "white",
                                        borderRadius: "4px",
                                        height: "40px",
                                        padding: "0 10px",
                                        position: "relative",
                                    }}
                                >
                                    <Box
                                        sx={{
                                            flexGrow: 1,
                                            textAlign: "left",
                                            fontSize: "16px",
                                            fontWeight: "400",
                                            padding: "14px 16.5px",
                                            lineHeight: "1.4375em",
                                            fontFamily: "'Roboto', 'Helvetica', 'Arial', sans-serif",
                                        }}

                                    >
                                        {numcopies + numclonecopies}
                                    </Box>
                                    <Button
                                        disableRipple
                                        style={{
                                            position: "absolute",
                                            border: "none",
                                            borderRadius: "50px",
                                            transform: "translate(-50%, -40%)",
                                            top: "40%",
                                            left: "90%",
                                            "&:hover": {
                                                backgroundColor: "black",
                                                boxShadow: "none",
                                            },
                                        }}
                                        onClick={() => {
                                            const value = numclonecopies + 1;
                                            setnumclonecopies(value);
                                            setErrors((prev) => ({ ...prev, numcopies: "" }))

                                            if (value > clonecopies.length) {
                                                const newCopies = Array.from({
                                                    length: value - clonecopies.length,
                                                }).map(() => ({ shell: "unknown" }));
                                                setclonecopies([...clonecopies, ...newCopies]);
                                            }
                                        }}
                                    >
                                        <img src={add}
                                            style={{
                                                width: "20px",
                                            }}
                                        />
                                    </Button>
                                </Box>
                                {errors.numcopies && (
                                    <Typography sx={{ padding: "2px 10px", color: "#d32f2f", fontSize: "12px" }}>
                                        {errors.numcopies}
                                    </Typography>
                                )}
                            </Box>

                        </Grid>
                    </Grid>
                    {/* copies */}
                    <Box
                        sx={{
                            display: numcopies == 0 ? 'none' : 'block',
                            maxHeight: '500px',
                            overflowY: 'auto',
                            border: '2px solid #ccc',
                            borderRadius: '10px',
                            boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)',
                            padding: '10px',
                            backgroundColor: '#f9f9f9',
                            overflowX: 'hidden'
                        }}
                    >
                        {Array.from({ length: numcopies }).map((_, index) => (
                            <Box
                                key={index}
                                sx={{
                                    marginBottom: '20px',
                                    display: 'flex',
                                    gap: '10px',
                                    alignItems: 'center',
                                }}
                            >
                                <Typography sx={{ fontSize: '17px', marginBottom: '5px', fontWeight: 'bold', marginTop: '40px' }}>#{index + 1}</Typography>

                                {/* Position Field */}
                                <Box sx={{ flex: 1 }}>
                                    <Typography sx={{ fontSize: '17px', marginBottom: '5px' }}>Vị trí:</Typography>
                                    <TextField
                                        fullWidth
                                        type="text"
                                        variant="outlined"
                                        onChange={(e) => handleInputChange(index, 'shell', e.target.value)}
                                        value={copies[index]?.shell || ''}
                                        sx={{
                                            backgroundColor: "white",
                                            "& .MuiOutlinedInput-root": {
                                                height: "40px",
                                                "& fieldset": {
                                                    borderColor: "black", // Đổi màu viền
                                                },
                                            },
                                        }}
                                    />
                                </Box>

                                {/* State Field */}
                                <Box sx={{ flex: 1 }}>
                                    <Typography sx={{ fontSize: '17px', marginBottom: '5px' }}>Trạng thái:</Typography>
                                    <FormControl fullWidth variant="outlined"
                                        sx={{
                                            backgroundColor: "white",
                                            "& .MuiOutlinedInput-root": {
                                                height: "40px",
                                                "& fieldset": {
                                                    borderColor: "black", // Đổi màu viền
                                                },
                                            },
                                        }}
                                    >
                                        <Select
                                            value={copies[index]?.status || ''}
                                            onChange={(e) => handleInputChange(index, 'status', e.target.value)}
                                        >
                                            <MenuItem value="available">Có sẳn</MenuItem>
                                            <MenuItem value="unavailable">Không có sẳn</MenuItem>
                                        </Select>
                                    </FormControl>
                                </Box>
                                <Box>
                                    <img
                                        src={close}
                                        alt="Close"
                                        style={{ cursor: 'pointer', width: '20px', height: '20px', padding: '5px', marginTop: '30px', borderRadius: '20px' }}
                                        onClick={() => handleRemoveCopy(index)}
                                    />
                                </Box>
                            </Box>
                        ))}
                    </Box>
                    {/* clone copies */}
                    <Box
                        sx={{
                            display: numclonecopies == 0 ? 'none' : 'block',
                            maxHeight: '500px',
                            overflowY: 'auto',
                            border: '2px solid #ccc',
                            borderRadius: '10px',
                            boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)',
                            padding: '10px',
                            backgroundColor: '#f9f9f9',
                            overflowX: 'hidden'
                        }}
                    >
                        <Typography sx={{ fontSize: "17px", fontWeight: 'bold' }}>Những bản sao chép mới:</Typography>
                        {Array.from({ length: numclonecopies }).map((_, index) => (
                            <Box
                                key={index}
                                sx={{
                                    marginBottom: '20px',
                                    display: 'flex',
                                    gap: '10px',
                                    alignItems: 'center',
                                }}
                            >
                                <Typography sx={{ fontSize: '17px', marginBottom: '5px', fontWeight: 'bold', marginTop: '40px' }}>#{index + 1}</Typography>

                                {/* Position Field */}
                                <Box sx={{ flex: 1 }}>
                                    <Typography sx={{ fontSize: '17px', marginBottom: '5px' }}>Vị trí:</Typography>
                                    <TextField
                                        fullWidth
                                        type="text"
                                        variant="outlined"
                                        onChange={(e) => handleInputChangeClone(index, 'shell', e.target.value)}
                                        value={clonecopies[index]?.shell || ''}
                                        sx={{
                                            backgroundColor: "white",
                                            "& .MuiOutlinedInput-root": {
                                                height: "40px",
                                                "& fieldset": {
                                                    borderColor: "black", // Đổi màu viền
                                                },
                                            },
                                        }}
                                    />
                                </Box>

                                {/* State Field */}
                                <Box sx={{ flex: 1 }}>
                                    <Typography sx={{ fontSize: '17px', marginBottom: '5px' }}>Trạng thái:</Typography>
                                    <FormControl fullWidth variant="outlined"
                                        sx={{
                                            backgroundColor: "white",
                                            "& .MuiOutlinedInput-root": {
                                                height: "40px",
                                                "& fieldset": {
                                                    borderColor: "black", // Đổi màu viền
                                                },
                                            },
                                        }}
                                    >
                                        <Select
                                            value={clonecopies[index]?.status || ''}
                                            onChange={(e) => handleInputChangeClone(index, 'status', e.target.value)}
                                        >
                                            <MenuItem value="available">Có sẳn </MenuItem>
                                            <MenuItem value="unavailable">Không có sẳn</MenuItem>
                                        </Select>
                                    </FormControl>
                                </Box>
                                <Box>
                                    <img
                                        src={close}
                                        alt="Close"
                                        style={{ cursor: 'pointer', width: '20px', height: '20px', padding: '5px', marginTop: '30px', borderRadius: '20px' }}
                                        onClick={() => handleRemoveCopyClone(index)}
                                    />
                                </Box>
                            </Box>
                        ))}
                    </Box>
                </Box>


                {/* Description */}
                <Box mb={3}
                    sx={{
                        display: "flex",
                        flexDirection: 'column',
                        gap: '10px'
                    }}>
                    <Typography variant="h6" sx={{ fontWeight: "bold" }}>2. Mô tả</Typography>
                    <TextField fullWidth type="text" variant="outlined" onChange={(e) => setdescription(e.target.value)}
                        placeholder="Enter book description"
                        multiline
                        rows={5}
                        sx={{
                            backgroundColor: "white",
                            margin: '0',
                            "& .MuiOutlinedInput-root": {
                                height: "120px",
                            },
                        }}
                        value={description || ""}
                    />
                </Box>

                {/* Image Upload */}
                <Box mb={3}>
                    <div style={{
                        display: "flex",
                        flexDirection: "row",
                        alignItems: 'flex-end',
                        gap: "10px"
                    }}>
                        <Typography variant="h6" sx={{ fontWeight: "bold" }}>3. Hình ảnh</Typography>
                        <Typography sx={{ fontSize: "14px", marginBottom: "3px" }}>(Thêm đường dẩn hình ảnh vào đây)</Typography>
                    </div>
                    <TextField fullWidth label="" variant="outlined" onChange={(e) => {
                        setimage(e.target.value)
                        setErrors((prev) => ({ ...prev, image: "" }))
                    }}
                        sx={{
                            backgroundColor: "white",
                            border: errors.image ? "1px solid red" : "1px solid black",
                            borderRadius: "10px",
                            margin: '0',
                            "& .MuiOutlinedInput-root": {
                                height: "60px", // Chiều cao của toàn bộ TextField
                            },
                        }}
                        error={!!errors.image}
                        helperText={errors.image}
                        value={image || ""}
                    />
                </Box>

                {/* Buttons */}
                <Box sx={{ display: 'flex', justifyContent: 'flex-end', gap: 2 }}>
                    <Button variant="outlined" color="secondary" sx={{ width: "170px" }} onClick={fecthInformation}>
                        Get infomation
                    </Button>
                    <Button variant="contained" color="primary" sx={{ width: "90px" }} onClick={() => {
                        handleUpdateBook()
                    }}>
                        Save
                    </Button>
                </Box>
            </form >
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
                    <Box
                        component="img"
                        src={checked}
                        alt="Success"
                        sx={{
                            maxHeight: "80px",
                            maxWidth: "80px",
                            objectFit: "contain",
                        }}
                    />
                    <DialogTitle sx={{ textAlign: "center", fontSize: "30px", padding: "10px 0 0 0" }}>Cập nhập thông tin sách thành công</DialogTitle>
                    <DialogTitle sx={{ textAlign: "center", fontSize: "14px", padding: "10px 0" }}>
                        Thông tin sách đã được cập nhập vào cơ sở dữ liệu.
                    </DialogTitle>
                </Box>
            </Dialog>
        </Box >
    );
}

export default UpdateBook;