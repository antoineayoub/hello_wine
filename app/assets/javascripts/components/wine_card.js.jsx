var WineCard = React.createClass({
  render: function() {

    return (
          <div className="col-xs-12">
            <div className="wine-card">
              <WineCardTitle wine_name={this.props.wine.name} />
              <WineCardBody
                wine={this.props.wine}
                onWishListClick={this.props.onWishListClick}
              />
              <WineCardButton wine_id={this.props.wine} />
            </div>
          </div>
    );
  }
});

