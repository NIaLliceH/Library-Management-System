import React, { useEffect, useState } from 'react';
import { Box, TextField, Select, MenuItem, InputLabel, FormControl, Button, Typography, Grid, Dialog, DialogTitle, } from '@mui/material';
import checked from "../../assets/checked.png";
import axiosInstance from '../../Axios';
const Addbook = () => {
    const [title, settitle] = useState("");
    const [category, setcategory] = useState("");
    const [copies, setcopies] = useState([]);
    const [numcopies, setnumcopies] = useState(0);
    const [pages, setpages] = useState(0);
    const [publisher, setpublisher] = useState("");
    const [description, setdescription] = useState("");
    const [image, setimage] = useState("");
    const [author, setauthor] = useState([]);
    const [edition, setedition] = useState("");

    const [allcategories, setallcategories] = useState([]);

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
    // kiem tra cac truong du lieu
    const [errors, setErrors] = useState({});
    const validateForm = () => {
        const newErrors = {};

        if (!title.trim()) newErrors.title = "Yêu cầu tiêu đề.";
        if (!publisher.trim()) newErrors.publisher = "Yêu cầu nhà xuất bản";
        if (!category.trim()) newErrors.category = "Yêu cầu thể loại.";
        if (numcopies <= 0) newErrors.numcopies = "Số lượng bản copies > 0.";
        if (pages <= 0) newErrors.pages = "Số lượng trang > 0.";
        if (!edition.trim()) newErrors.edition = "Yêu cầu phiên bản.";
        if (!image.trim()) newErrors.image = "Yêu cầu đường dẫn của ảnh.";



        setErrors(newErrors);

        return Object.keys(newErrors).length === 0;
    };

    useEffect(() => {
        const fecthCatories = async () => {
            const res = await axiosInstance.get('books/categories');
            setallcategories(res.data.data);
        }
        fecthCatories()
    }, [])

    // addbook
    const handleAdd = async () => {
        if (!validateForm()) return;
        const res = await axiosInstance.post('books/', {
            name: title,
            noValidCopies: numcopies,
            noPages: pages,
            publisher: publisher,
            description: description,
            imageUrl: image,
            copies: copies,
            authors: author,
            edition: edition,
            category: category,
        })
        if(res.status == 201)
            setSuccessModalOpen(true);
    }

    return (
        <Box sx={{
            padding: "20px 10%"
        }}>
            <Typography variant="h4" gutterBottom sx={{ fontWeight: 'bold' }}>
                Thêm sách
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
                        />
                    </Box>
                    <Box>
                        <Typography sx={{ fontSize: "17px" }}>Nhà xuất bản:</Typography>
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
                        />
                    </Box>

                    <Box>
                        <Typography sx={{ fontSize: "17px" }}>Tác giả:</Typography>
                        <TextField fullWidth type="text" variant="outlined" onChange={(e) => {
                            setauthor((e.target.value).split(",").map((au) => au.trim()))
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
                        />
                    </Box>
                    <Grid container spacing={2}>
                        <Grid item xs={3}>
                            <Typography sx={{ fontSize: "17px" }}>Thể loại:</Typography>
                            <FormControl
                                fullWidth
                                sx={{
                                    backgroundColor: "white",
                                    "& .MuiOutlinedInput-root": {
                                        height: "40px",
                                        "& fieldset": {
                                            borderColor: errors.category ? "red" : "black", // Đổi màu viền
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
                        <Grid item xs={3}>
                            <Typography sx={{ fontSize: "17px" }}>Phiên bản</Typography>
                            <TextField fullWidth type="text" variant="outlined" onChange={(e) => {
                                setedition(e.target.value)
                                setErrors((prev) => ({ ...prev, edition: "" }))
                            }}
                                sx={{
                                    backgroundColor: "white",
                                    "& .MuiOutlinedInput-root": {
                                        height: "40px",
                                        "& fieldset": {
                                            borderColor: errors.edition ? "red" : "black", // Đổi màu viền
                                        },
                                    },
                                }}
                                error={!!errors.edition}
                                helperText={errors.edition}
                            />
                        </Grid>
                        <Grid item xs={3}>
                            <Typography sx={{ fontSize: "17px" }}>Số lượng bản sao:</Typography>
                            <TextField fullWidth type="number" variant="outlined" onChange={(e) => {
                                setnumcopies(parseInt(e.target.value))
                                setErrors((prev) => ({ ...prev, numcopies: "" }))
                                if (e.target.value > copies.length) {
                                    const newCopies = Array.from({ length: e.target.value - copies.length }).map(() => ({ shell: '' }));
                                    setcopies([...copies, ...newCopies]);
                                } else {
                                    const newCopies = copies.slice(0, e.target.value)
                                    setcopies(newCopies);
                                }
                            }} value={String(numcopies) || ""}
                                onWheel={(e) => e.target.blur()}
                                sx={{
                                    backgroundColor: "white",
                                    "& .MuiOutlinedInput-root": {
                                        height: "40px",
                                        "& fieldset": {
                                            borderColor: errors.numcopies ? "red" : "black", // Đổi màu viền
                                        },
                                    },
                                }}
                                error={!!errors.numcopies}
                                helperText={errors.numcopies}
                            />
                        </Grid>
                        <Grid item xs={3}>
                            <Typography sx={{ fontSize: "17px" }}>Số lượng trang:</Typography>
                            <TextField fullWidth type="number" variant="outlined" onChange={(e) => {
                                setpages(parseInt(e.target.value))
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
                            />
                        </Grid>
                    </Grid>
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
                                        // value={copies[index]?.shell || ''}
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
                                            // value={copies[index]?.status}
                                            onChange={(e) => handleInputChange(index, 'status', e.target.value)}
                                        >
                                            <MenuItem value="available">Có sẳn</MenuItem>
                                            <MenuItem value="unavailable">Không có sẳn</MenuItem>
                                        </Select>
                                    </FormControl>
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
                        multiline
                        rows={5}
                        sx={{
                            margin: '0',
                            backgroundColor: "white",
                            "& .MuiOutlinedInput-root": {
                                height: "130px",
                                "& fieldset": {
                                    borderColor: "black", // Đổi màu viền
                                },
                            },
                        }}
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
                        <Typography sx={{ fontSize: "14px", marginBottom: "3px" }}>(Thêm đường dẫn hình ảnh ở đây)</Typography>
                    </div>
                    <TextField fullWidth label="" variant="outlined" onChange={(e) => {
                        setimage(e.target.value)
                        setErrors((prev) => ({ ...prev, image: "" }))
                    }}
                        sx={{
                            border: errors.image ? "1px solid red" : "1px solid black",
                            backgroundColor: "white",
                            "& .MuiOutlinedInput-root": {
                                height: "40px",
                                "& fieldset": {
                                    borderColor: errors.image ? "red" : "black", // Đổi màu viền
                                },
                            },
                        }}
                        error={!!errors.image}
                        helperText={errors.image}
                    />
                </Box>

                {/* Buttons */}
                <Box sx={{ display: 'flex', justifyContent: 'flex-end', gap: 2 }}>
                    <Button variant="contained" color="success" sx={{ width: "90px" }} onClick={handleAdd}>
                        Gửi
                    </Button>
                </Box>
            </form>
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
                    <DialogTitle sx={{ textAlign: "center", fontSize: "30px", padding: "10px 0 0 0" }}>Thêm sách thành công</DialogTitle>
                    <DialogTitle sx={{ textAlign: "center", fontSize: "14px", padding: "10px 0" }}>
                        Sách bao gồm các thông tin được nhập vào đã được thêm vào cơ sở dữ liệu
                    </DialogTitle>
                </Box>
            </Dialog>
        </Box>
    );
}

export default Addbook;