var QuestionBackButton = React.createClass({
  handleClick: function(){
    this.props.onSkipQuestion()
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
