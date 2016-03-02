var WineCardButton = React.createClass({

  // add function to handleName with if condition

  render: function() {
    var button_url = {
      wine: this.props.wine_id
    };
    return (
      <div>
        <div className="card-title">
          <a href='/wines' className="button-submit">GO GET IT</a>
        </div>
      </div>
    );
  }
});

