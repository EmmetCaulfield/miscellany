import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.geometry.Bounds;
import javafx.scene.Node;
import javafx.scene.shape.Line;
import javafx.scene.layout.Region;
import javafx.scene.chart.XYChart;
import javafx.scene.chart.NumberAxis;

/**
 * CrosshairRegion is a {@link Region} subclass that draws crosshairs
 * on an {@link XYChart} passed as an argument to the constructor.
 */
public class CrosshairRegion extends Region {
    private Line hLine = new Line(); // 1px solid black is default
    private Line vLine = new Line();
    private double x = Double.NaN;
    private double y = Double.NaN;
    private double xMin = Double.NaN;
    private double yMin = Double.NaN;


    /**
     * Sole constructor: instantiates a CrosshairRegion on an {@link XYChart}.
     *
     * @param  chart  the XYChart that the crosshairs are to be drawn on
     * @return        a CrosshairRegion instance
     */
    public CrosshairRegion(XYChart chart) {
	super();
	this.getChildren().addAll(chart, hLine, vLine);
	this.initBounds();
	this.initListeners();
    }


    /**
     * Returns a reference to the {@link XYChart} that this
     * CrosshairRegion draws on
     *
     * @return        reference to an XYChart 
     */
    public XYChart getChart() {
	return (XYChart)getChildren().get(0);
    }

    /**
     * Resizes this CrosshairRegion, intended to be connected to
     * window resize events
     */
    protected void resize() {
	initBounds();
	if( !Double.isNaN(x) ) {
	    double dispX = ((NumberAxis)getChart().getXAxis()).getDisplayPosition(x);
	    vLine.setStartX( dispX );
	    vLine.setEndX( dispX );
	}
	if( !Double.isNaN(y) ) {
	    double dispY = ((NumberAxis)getChart().getYAxis()).getDisplayPosition(y);
	    hLine.setStartY( dispY );
	    hLine.setEndY( dispY );
	}
    }

    /**
     * Initializes the bounds of the CrosshairRegion based on the
     * XYChart contained within
     */
    public void initBounds() {
	Node       bg = getChart().lookup(".chart-plot-background");
	Bounds   bbox = bg.localToScene(bg.getBoundsInLocal());
	double   xMax = bbox.getMaxX();
	double   yMax = bbox.getMaxY();

	xMin = bbox.getMinX();
	yMin = bbox.getMinY();
	hLine.setStartX(xMin);
	hLine.setEndX(xMax);
	vLine.setStartY(yMin);
	vLine.setEndY(yMax);
    }

    /**
     * Updates the crosshair position to nx, ny
     *
     * @param  nx  the x-coordinate of the crosshair center
     * @param  ny  the y-coordinate of the crosshair center
     */
    public void update(Number nx, Number ny) {
	x = nx.doubleValue();
	y = ny.doubleValue();
	XYChart c = getChart();
	double dispX = ((NumberAxis)c.getXAxis()).getDisplayPosition(x);
	double dispY = ((NumberAxis)c.getYAxis()).getDisplayPosition(y);
	hLine.setStartY(y+yMin);
	hLine.setEndY(y+yMin);
	vLine.setStartX(x+xMin);
	vLine.setEndX(x+xMin);
    }

    /**
     * Connects ChangeListeners to resize the crosshairs and the contained XYChart
     */
    protected void initListeners() {
	widthProperty().addListener(new ChangeListener<Number>() {
		@Override public void changed(ObservableValue<? extends Number> observableValue, Number oldSceneWidth, Number newSceneWidth) {
		    getChart().setPrefWidth(newSceneWidth.doubleValue());
		    resize();
//		    System.out.println("CHPWidth: " + newSceneWidth);
		}
	    });
	heightProperty().addListener(new ChangeListener<Number>() {
		@Override public void changed(ObservableValue<? extends Number> observableValue, Number oldSceneHeight, Number newSceneHeight) {
		    getChart().setPrefHeight(newSceneHeight.doubleValue());
		    resize();
//		    System.out.println("CHPHeight: " + newSceneHeight);
		}
	    });
    }
}
