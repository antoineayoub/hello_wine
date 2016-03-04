var QuestionFooter = React.createClass({
  render: function() {

    return (
      <div className="footer-question">
        <div className="col-xs-12 text-center">
          <span>more than </span>
          <span className="figure">
                {Math.max(this.props.nbWines, 85)}
          </span>
          <span> wines around you.</span>
          <div>
            <i className="fa fa-smile-o"></i>
          </div>
        </div>
      </div>
    )
  }
});
