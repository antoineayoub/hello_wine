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
              <WineCardButton
                store_id={this.props.wine.store.id}
                wine={this.props.wine}
                latitude={this.props.latitude}
                longitude={this.props.longitude} />
            </div>
          </div>
    );
  }
});

