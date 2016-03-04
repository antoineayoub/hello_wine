var WineCards = React.createClass({

  getInitialState: function() {
    return {
      hasWishlist: false,
      wishlistedWines: []
   }
  },

  handleWishListApp: function(wine) {
    var postWishList = this.state.wishlistedWines
    postWishList.push(wine)
    this.setState({
      hasWishlist: true,
      wishlistedWines: postWishList
    });
  },

  render: function() {
    var that = this;
    return (
      <div>
        <WineWishList wishlistedWines={this.state.wishlistedWines} hasWishlist={this.state.hasWishlist} key={this.state.key}/>
        <div className="container">
          <div className="row">
            <SwipeViews>
              {this.props.wines.map(function(wine, index){
                return (
                    <div title={'swipe' + index + 1} key={index} ref ='winecard'>
                      <WineCard
                        wine={wine}
                        onWishListClick={that.handleWishListApp}
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
