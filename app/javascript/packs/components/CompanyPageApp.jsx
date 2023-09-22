import React from "react";
import ReactDOM from "react-dom";
import axios from "axios";

class CompanyPageApp extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      companyPageData: [],
    };
    this.getCompanyPageData = this.getCompanyPageData.bind(this);
  }

  componentDidMount() {
    this.getCompanyPageData();
  }

  getCompanyPageData() {
    axios
      .get("/1/index")
      .then((response) => {
        const companyPageData = response.data;
        this.setState({ companyPageData });
      })
      .catch((error) => {
        console.log(error);
      });
  }

  render() {
    return (
      <div>
        <h2>Hello From React</h2>
        <p>{this.state.companyPageData.id}</p>
        <p>{this.state.companyPageData.experience_requirements}</p>
        <p>{this.state.companyPageData.fresher_requirements}</p>
        <p>{this.state.companyPageData.fresher_second_requirements}</p>
      </div>
    );
  }
}

document.addEventListener("turbolinks:load", () => {
  const app = document.getElementById("company-page-app");
  app && ReactDOM.render(<CompanyPageApp />, app);
});
