import classNames from "classnames/bind";
import styles from './DefaultLayout.module.css';
import SideBar from '../nav/SideBar'
const clx = classNames.bind(styles);

function DefaultLayout({children}){
    return (
        <div className={clx('wrapper')}>
            <SideBar />
            <div className={clx('content')}>
                {children}
            </div>
        </div>
    )
}

export default DefaultLayout;