var WineCard = React.createClass({
  render: function() {

    return (
          <div className="col-xs-12" id={"wine-"+this.props.wine.id}>
            <div className="wine-card">
              <WineCardTitle wine_name={this.props.wine.name} />
              <WineCardBody
                wine={this.props.wine}
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

