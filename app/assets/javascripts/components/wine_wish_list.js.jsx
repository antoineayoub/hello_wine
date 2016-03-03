var WineWishList = React.createClass({

  render: function() {

    var wishHeader = classNames({
      'wineNotWish': !this.props.hasWishlist,
      'wineWishList': this.props.hasWishlist
    });


    return (
      <div className={wishHeader} onClick={this.handleClick} ref='picture'> {this.mountWinePics()} </div>
    )
  },

  mountWinePics: function() {
    var winePic;
    if(this.props.wishlistedWines.length === 0){
        winePic = "no wishlisteditems";
    } else {
      return(
        <div>
          { this.props.wishlistedWines.map(function(wine){
              return (
                <img src={wine.url} height="40" width="40"/>
              )
            })
          }
        </div>
      )
    }
  }
});
