var WineCardButton = React.createClass({

  // add function to handleName with if condition
  handleClick: function() {
    window.location.href = "/wines/"+this.props.wine.id+"?latitude="+this.props.latitude+"&longitude="+this.props.longitude+"&store_id="+this.props.wine.store.id+"/"
  },
  render: function() {
    return (
      <div>
        <div className="card-title">
          <div onClick={this.handleClick} onTouch={this.handleClick} onPress={this.handleClick} onClick={this.handleClick} className="button-submit">GO GET IT</div>
        </div>
      </div>
    );
  }
});

