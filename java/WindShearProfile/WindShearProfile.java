import java.lang.Math;
import java.util.Arrays;
import javafx.application.Application;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.geometry.Orientation;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.Label;
import javafx.scene.control.Slider;
import javafx.scene.control.Tooltip;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.layout.Priority;
import javafx.scene.layout.Region;
import javafx.scene.text.TextAlignment;
import javafx.stage.Stage;
import javafx.event.EventType;
import javafx.event.EventHandler;
import javafx.util.StringConverter;

/**
 * An application that illustrates log-law wind-shear in the Earth's boundary layer.
 */
public class WindShearProfile extends Application {
    private NumberAxis xAxis;
    private NumberAxis yAxis;
    private LineChart<Number,Number> chart;
    private CrosshairRegion cross;
    private double v0 = 5.0d;
    private double h0 = 3.0d;
    private int z0i = 4;
    private Double[] roughness = {0.0002, 0.0024, 0.03, 0.055, 0.1, 0.2, 0.4, 0.8, 1.6}; 
    private ObservableList<XYChart.Data<Number,Number>> list;


    /**
     * Explicit constructor to replace default
     */
    public WindShearProfile() {
	super();
    }

    /**
     * Creates a {@link LineChart} and its associated data for the
     * currently configured wind conditions. 
     */
    public Region createChart() {
	xAxis = new NumberAxis("Wind Speed (m/s)", 0.0d, 25.0d, 5.0d);
	yAxis = new NumberAxis("Height (m)", 0.0d, 100.0d, 10.0d);

	// The first point is always 0,0:
	list = FXCollections.observableArrayList( Arrays.asList(new XYChart.Data<Number,Number>(0d, 0d)) );

	// We need to wrap the list in a series for LineChart()
	ObservableList<XYChart.Series<Number,Number>> data = FXCollections.observableArrayList(
	    Arrays.asList(new XYChart.Series<Number,Number>(list)));
	double common_factor = v0/Math.log(h0/roughness[z0i].doubleValue());
	for(int h=1; h<=100; h++) {
	    double v = common_factor * Math.log((double)h/roughness[z0i].doubleValue());
	    list.add(new XYChart.Data<Number,Number>(v, (double)h));
	}

	chart = new LineChart<Number,Number>(xAxis, yAxis, data);
	chart.setCreateSymbols(false);
	chart.setLegendVisible(false);
	chart.setAnimated(false);
	Tooltip t = new Tooltip("Click or drag crosshairs to set wind height and speed datum.");
	Tooltip.install(chart, t);
	cross = new CrosshairRegion(chart);

	Node chartBg = chart.lookup(".chart-plot-background");
	chartBg.setOnMouseDragged(mouseHandler);
	chartBg.setOnMouseReleased(mouseHandler);

	return cross;
    }
 
    /**
     * Recomputes chart data based on (potentially) updated wind conditions
     */
    public void recompute() {
	double common_factor = v0/Math.log(h0/roughness[z0i].doubleValue());
	for(XYChart.Data<Number,Number> datum : list.subList(1, list.size())) {
	    double v = common_factor * Math.log( datum.getYValue().doubleValue() / roughness[z0i].doubleValue());
	    datum.setXValue( v );
	}
    }

    /**
     * Effective entry-point; sets up GUI including all event plumbing
     */
    @Override public void start(Stage stage) {
	VBox vbox = new VBox(8);
	HBox hbox = new HBox(8);

	Slider slider = new Slider(0, roughness.length-1, z0i);
	slider.setOrientation( Orientation.VERTICAL );
	slider.setShowTickMarks(true);
	slider.setShowTickLabels(true);
	slider.setMajorTickUnit(1d);
	slider.setMinorTickCount(0);
	slider.setBlockIncrement(1d);
	slider.setSnapToTicks(true);
	slider.setTooltip(new Tooltip("Roughness length (m)"));

	slider.valueProperty().addListener(new ChangeListener<Number>() {
		public void changed(ObservableValue<? extends Number> ov,
				    Number old_val, Number new_val) {
		    z0i = new_val.intValue();
		    recompute();
		}
	    });

	slider.setLabelFormatter(new StringConverter<Double>() {
		@Override public String toString(Double d) {
		    return Double.toString(roughness[d.intValue()]);
		}
		@Override public Double fromString(String s) {
		    final int idx=Arrays.asList(roughness).indexOf(new Double(s));
		    return new Double(idx);
		}
	    });

	Label sl = new Label("z0");
	sl.setLabelFor(slider);
	sl.setTextAlignment(TextAlignment.RIGHT);
	vbox.getChildren().addAll( slider, sl );
	vbox.setVgrow(slider, Priority.ALWAYS);
	Region plot = createChart();
	hbox.getChildren().addAll( plot, vbox );
	hbox.setHgrow(plot, Priority.ALWAYS);
	Scene scene = new Scene( hbox );
	scene.getStylesheets().add("WindShearProfile.css");
	stage.setTitle("Wind Shear (Log Law)");
	stage.setScene(scene);
	stage.sizeToScene();
        stage.show();

	cross.resize();
	cross.update(xAxis.getDisplayPosition(v0), yAxis.getDisplayPosition(h0));

	scene.widthProperty().addListener(new ChangeListener<Number>() {
		@Override public void changed(ObservableValue<? extends Number> observableValue, Number oldSceneWidth, Number newSceneWidth) {
		    chart.setPrefWidth(newSceneWidth.doubleValue());
		    System.out.println("Width: " + newSceneWidth);
		}
	    });
	scene.heightProperty().addListener(new ChangeListener<Number>() {
		@Override public void changed(ObservableValue<? extends Number> observableValue, Number oldSceneHeight, Number newSceneHeight) {
		    chart.setPrefHeight(newSceneHeight.doubleValue());
		    System.out.println("Height: " + newSceneHeight);
		}
	    });
    }
 
    /**
     * Mouse event handler to handle interactive moving of wind datum
     * at crosshair center
     */
    EventHandler<MouseEvent> mouseHandler = new EventHandler<MouseEvent>() {
	@Override public void handle(MouseEvent mevt) {
	    EventType et = mevt.getEventType();
	    cross.update(mevt.getX(),mevt.getY());
	    Number x = xAxis.getValueForDisplay(mevt.getX());
	    Number y = yAxis.getValueForDisplay(mevt.getY());
	    h0 = y.doubleValue();
	    v0 = x.doubleValue();
	    recompute();
	}
    };


    public static void main(String[] args) {
        launch(args);
    }
}
