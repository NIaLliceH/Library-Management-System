import { React, useState, useEffect } from "react";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement,
} from "chart.js";
import { Bar } from "react-chartjs-2";
import { Doughnut } from "react-chartjs-2";
import classNames from "classnames/bind";
import styles from "./home.module.css";

const clx = classNames.bind(styles);

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend);
ChartJS.register(ArcElement, Tooltip, Legend);

const Dashboard = () => {
  const [DashBoardData, setData] = useState([]);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async (e) => {
      try {
        const response = await fetch("http://localhost:3001/api/admin/getnum", {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        });

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const result = await response.json();
        
        setData(result.data);

      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const options = {
    responsive: true,
    plugins: {
      legend: {
        position: 'top',
      },
    },

    cutout: '60%',
  };
  const barData = {
    labels: ["Mon", "Tues", "Wed", "Thu", "Fri", "Sat", "Sun"],
    datasets: [
      {
        label: "Số sách mượn trong tuần",
        data: [1, 2, 0,0,0,0,0],
        backgroundColor: "#4A90E2",
      },
    ],
  };

  const doughnutData = {
    labels: ["Đã trả", "Còn lại"],
    datasets: [
      {
        // data: [DashBoardData?.dueToday?.returned || 0, DashBoardData?.dueToday?.notReturned || 0],
        data: [1, 2],
        backgroundColor: ["#36A2EB", "#FFCE56"],
      },
    ],
  };

  return (
    <div className={clx("dashboard-container")}>

      {loading && <p>Loading...</p>}
      <div className={clx("summary")}>
        <div className={clx("summary-item")}>
          <h4>Tổng sách</h4>
          <p className={clx("summary-value")}>{DashBoardData.numBooks}</p>
        </div>
        <div className={clx("summary-item")}>
          <h4>Tổng sách đang mượn</h4>
          <p className={clx("summary-value")}>{DashBoardData.numBorrowTickets}</p>
        </div>
        <div className={clx("summary-item")}>
          <h4>Tổng sách đang giữ</h4>
          <p className={clx("summary-value")}>{DashBoardData.numHoldTickets}</p>
        </div>
      </div>

      <div className={clx("charts")}>
        <div className={clx("chart")}>
          <h4>Số sách mượn trong tuần: {DashBoardData.numWeeklyBorrow}</h4>
          <Bar data={barData} />
        </div>
        <div className={clx("donut-chart")}>
        <h4>Số sách đến hạn trong ngày: 
          {/* {DashBoardData?.dueToday?.total || 0} */}
          {' '}  3
        </h4>
          <Doughnut data={doughnutData} options={options} />
        </div>
      </div>
    </div>
    
  );
};

export default Dashboard;
