import React, { useState } from 'react';
import { TextField, Button, Box, Container, Typography } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import hide from "../../assets/hide.png";
import unhide from "../../assets/unhide.png";
import emailIcon from "../../assets/email.png";
import logo from "../../assets/logo.png";
import loginImage from "../../assets/loginImage.png";

import './login.css';
import axiosInstance from '../../Axios';
const Login = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errors, seterrors] = useState([]);
  const navigate = useNavigate();
  // hide or unhide 
  const [isHide, setIssHide] = useState(true);

  const checkTextfield = () => {
    const newErrors = {};

    if (!email.trim()) newErrors.email = "Email is required.";
    if (!password.trim()) newErrors.password = "Password is required.";

    seterrors(newErrors);

    return Object.keys(newErrors).length === 0;
  };
  const handleLogin = async () => {
    if (!checkTextfield()) return;
    let res
    try {
      res = await axiosInstance.post('authen/login', {
        email: email,
        password: password
      })
    }
    catch (err) {
      if (err.response.data.message == "Email không chính xác")
        seterrors((prev) => ({ ...prev, email: "Email is incorrect!" }))
      else if (err.response.data.message == "Sai mật khẩu")
        seterrors((prev) => ({ ...prev, password: "Password is incorrect!" }))
      return
    }
    if (res.status == 200 && res.data.data.role == "admin") {
      localStorage.setItem("userID", res.data.data.userId);
      navigate('home');
    }
  }

  return (
    <Container sx={{ width: "100vw", height: "100vh", display: "flex", flexDirection: "row", overflow: "hidden" }}>
      <Container sx={{
        flex: "2",
        display: "flex",
        flexDirection: "column",
      }}
      >
        <Box sx={{
          height: "100px",
          display: "flex",
          flexDirection: "row",
          alignItems: "center",
          gap: "20px",
          margin: "0 20px",
        }}>
          <img src={logo} style={{ width: '100px', height: "auto" }} />
          <p style={{ textAlign: "center", fontSize: "24px", margin: 0, fontWeight: "bold" }}>BKLib</p>
        </Box>

        <Container sx={{
          flex: 1,
          display: 'flex',
          flexDirection: 'column',
          alignContent: "center",
          justifyContent: "center",
          margin: "0 0 35% 0"
        }}>
          <Typography variant="h8" sx={{ fontWeight: 'thin', color: 'black' }}>
            Start your work
          </Typography>
          <Typography variant="h5" sx={{ margin: "5px 0 10px 0", fontWeight: 'thin', color: 'black' }}>
            Login into BKLib
          </Typography>
          <Box sx={{ textAlign: 'center', }}>
            <div
              style={{
                width: "100%",
                position: "relative",
              }}
            >
              <TextField
                label="Email"
                type="text"
                variant="outlined"
                fullWidth
                margin="normal"
                value={email}
                onChange={(e) => {
                  setEmail(e.target.value)
                  seterrors((prev) => ({ ...prev, email: "" }))
                }}
                InputLabelProps={{ shrink: true }}
                sx={{
                  width: "100%",
                  '& .MuiOutlinedInput-root': {
                    borderRadius: '10px',
                    color: 'black'
                  },
                  '& .MuiInputLabel-root': {
                    fontWeight: 'bold',
                    fontSize: "20px",
                    color: 'black'
                  },
                  '& .MuiInputLabel-root.Mui-focused': {
                    color: 'black', // Màu label khi focused
                  },
                  '& .MuiOutlinedInput-root.Mui-focused .MuiOutlinedInput-notchedOutline': {
                    borderColor: 'black', // Màu viền khi focused
                  },
                }}
                error={!!errors.email}
                helperText={errors.email}
              />
              <Box
                style={{
                  position: "absolute",
                  border: "none",
                  borderRadius: "50px",
                  transform: "translate(-50%, -40%)",
                  top: "50%",
                  left: "90%",
                }}>
                <img src={emailIcon}
                  style={{
                    width: "30px",

                  }}
                />
              </Box>
            </div>




            <div
              style={{
                width: "100%",
                position: "relative",
              }}
            >
              <TextField
                label="Mật khẩu"
                type={isHide ? 'password' : 'text'}
                variant="outlined"
                fullWidth
                margin="normal"
                value={password}
                onChange={(e) => {
                  setPassword(e.target.value)
                  seterrors((prev) => ({ ...prev, password: "" }))
                }}
                InputLabelProps={{ shrink: true, }}
                sx={{
                  '& .MuiOutlinedInput-root': {
                    borderRadius: '10px',
                    color: 'black'
                  },
                  '& .MuiInputLabel-root': {
                    fontWeight: 'bold',
                    fontSize: "20px",
                    color: 'black'
                  },
                  '& .MuiInputLabel-root.Mui-focused': {
                    color: 'black', // Màu label khi focused
                  },
                  '& .MuiOutlinedInput-root.Mui-focused .MuiOutlinedInput-notchedOutline': {
                    borderColor: 'black', // Màu viền khi focused
                  },
                }}
                error={!!errors.password}
                helperText={errors.password}
              />
              <Button
                disableRipple
                style={{
                  position: "absolute",
                  border: "none",
                  borderRadius: "50px",
                  transform: "translate(-50%, -40%)",
                  top: "50%",
                  left: "90%",
                  "&:hover": {
                    backgroundColor: "blue",
                    boxShadow: "none",
                  },
                }}
                onClick={() => setIssHide(!isHide)}
              >
                <img src={isHide ? hide : unhide}
                  style={{
                    width: "30px",
                  }}
                />
              </Button>
            </div>

            <Button
              variant="contained"
              color="primary"
              fullWidth
              sx={{
                marginTop: 3,
                borderRadius: '5px',
                padding: '10px',
                fontWeight: 'bold',
                boxShadow: '0px 5px 15px rgba(63, 81, 181, 0.3)',
                '&:hover': {
                  backgroundColor: '#3f51b5',
                  boxShadow: '0px 10px 20px rgba(63, 81, 181, 0.3)',
                },
              }}
              onClick={handleLogin}
            >
              Login
            </Button>


          </Box>
        </Container>
      </Container>
      <Container sx={{
        position: "relative",
        flex: 3,
        zIndex: -1,
      }}>
        <img className='loginImage' src={loginImage}
          style={{
            position: "absolute",
            width: "150%",
            top: "10%",
            left: "-20%"
          }}
        />
      </Container>
    </Container>
  );
};

export default Login;
