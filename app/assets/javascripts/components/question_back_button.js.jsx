var QuestionBackButton = React.createClass({
  handleClick: function(){
    var that = this;
    this.props.nextPage();
    setTimeout(function(){
      that.props.onSkipQuestion();
    },500);
  },
  render: function() {
    return (
      <div>
        <div className="col-xs-12">
          <div className="padded-top-bottom-xs btn-skip">
            <a className="btn btn-back" onClick={this.handleClick}>I dont care</a>
          </div>
        </div>
      </div>
    )
  }
});
