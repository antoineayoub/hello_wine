var WineCardBody = React.createClass({

  handleClick: function(){
     this.props.onWishListClick(this.props.wine);
  },

  render: function() {
    var imgStyle = {
      backgroundImage: 'url(' + this.props.wine.url + ')',
      backgroundRepeat: 'no-repeat',
      backgroundPosition: 'center',
      backgroundSize: 'cover'
    };

    return (
      <div>
        <div className="card-header">
          <div className="card-header-side">
            <div className="card-kpis">
              <div className="card-kpis-container">
                <div className="card-kpi card-kpi-price card-kpi-green">
                  <div className="kpi-picto">
                    <div className="font-awesome-circled">
                      <i className="fa fa-eur eur-spec"></i>
                    </div>
                  </div>
                  <div className="kpi-text">
                    {Math.round(this.props.wine.price)}€
                  </div>
                </div>
                <hr/>
                <div className="card-kpi card-kpi-distance card-kpi-red">
                  <div className="kpi-picto">
                    <div className="font-awesome-circled">
                      <i className="fa fa-map-marker marker-spec" ></i>
                    </div>
                  </div>
                  <div className="kpi-text">
                    { Math.round(this.props.wine.distance * 1000) }m
                  </div>
                </div>
                <hr/>
                <div className="card-kpi card-kpi-rating card-kpi-green">
                  <div className="kpi-picto">
                    <div className="font-awesome-circled">
                      <i className="fa fa-heart"></i>
                    </div>
                  </div>
                  <div className="kpi-text">
                      {this.props.wine.avg_rating}
                      <span className="ext-spec"> /5</span>
                  </div>
                </div>
                <div className="media-query-500">
                  <hr/>
                  <div className="card-kpi">
                    <div className="kpi-text kpi-overall">
                      <span className="wine-spec">
                        {Math.round(this.props.wine.score)}%
                      </span>
                      <div className="media wine-text-spec" >WINE</div>
                      <div className="media fit-spec" >FIT</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="card-header-side">
            <div className="bookmark-center card-header-side bottle-image"
                  style={imgStyle}>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
