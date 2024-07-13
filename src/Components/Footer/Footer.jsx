import { Link } from 'react-router-dom';
import { FaArrowLeft } from "react-icons/fa6";

function Footer() {
    return(
        <>
        <div
          className="container-fluid bg-dark text-white-50 footer pt-5 mt-5 wow fadeIn"
          data-wow-delay="0.1s"
        >
          <div className="container py-5">
            <div className="row g-5">
             
              <div className="col-lg-3 col-md-6">
                <h5 className="text-white mb-4">Quick Links</h5>
                
                <Link to="/About" className="btn btn-link text-white-50">About Us</Link>
                
                <Link to="/Services" className="btn btn-link text-white-50">Our Services</Link>
              
                <p className=" btn-link text-white-50">
                 <span className='fs-5'><FaArrowLeft /></span>  Contact Us
                </p>
              </div>
              <div className="col-lg-3 col-md-6">
                <h5 className="text-white mb-4">Photo Gallery</h5>
                <div className="row g-2 pt-2">
                  <div className="col-4">
                    <img
                      className="img-fluid rounded bg-light p-1"
                      src="./src/img/property-1.jpg"
                      alt=""
                    />
                  </div>
                  <div className="col-4">
                    <img
                      className="img-fluid rounded bg-light p-1"
                      src="./src/img/property-2.jpg"
                      alt=""
                    />
                  </div>
                  <div className="col-4">
                    <img
                      className="img-fluid rounded bg-light p-1"
                      src="./src/img/property-3.jpg"
                      alt=""
                    />
                  </div>
                  <div className="col-4">
                    <img
                      className="img-fluid rounded bg-light p-1"
                      src="./src/img/property-4.jpg"
                      alt=""
                    />
                  </div>
                </div>
              </div>
              <div className="col-lg-3 col-md-6">
                <h5 className="text-white mb-4">THEME</h5>
                <p>ACCESSLITE </p>
                <div
                  className="position-relative mx-auto"
                  style={{ maxWidth: "400px" }}
                >
                  <input
                    className="form-control bg-transparent w-100 py-3 ps-4 pe-5"
                    type="text"
                    placeholder="Your email"
                  />
                  <button
                    type="button"
                    className="btn btn-secondary py-2 position-absolute top-0 end-0 mt-2 me-2"
                  >
                    SignUp
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div className="container">  
            <div className="copyright">
              <div className="row">
               
              </div>
            </div>
          </div>
        </div>
        </>
    );
}

export default Footer;
