var WineCards = React.createClass({

  getInitialState: function() {
    return {
      hasWishlist: false
   }
  },

  render: function() {
    var that = this;
    return (
      <div>
        <div className="container">
          <div className="row">
            <SwipeViews>
              {this.props.wines.map(function(wine, index){
                console.log(wine.id)
                return (
                    <div title={'swipe' + index + 1} key={index} ref ='winecard'>
                      <WineCard
                        wine={wine}
                        latitude={that.props.latitude}
                        longitude={that.props.longitude}
                      />
                    </div>
                )
              })}
            </SwipeViews>
          </div>
        </div>
      </div>
    );
  }
});
