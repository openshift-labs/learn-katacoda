package algorithms;

import java.util.HashMap;
import java.util.Map;

import org.apache.camel.BindToRegistry;
import org.apache.camel.PropertyInject;

@BindToRegistry("algorithm")
public class SimpleAlgorithm {

  @PropertyInject(value="algorithm.sensitivity", defaultValue = "0.0001")
  private double sensitivity;

  private Double previous;
  
  public Map<String, Object> predict(double value) {
    Double reference = previous;
    this.previous = value;

    if (reference != null && value < reference * (1 - sensitivity)) {
      Map<String, Object> res = new HashMap<>();
      res.put("value", value);
      res.put("operation", "buy");
      return res;
    } else if (reference != null && value > reference * (1 + sensitivity)) {
      Map<String, Object> res = new HashMap<>();
      res.put("value", value);
      res.put("operation", "sell");
      return res;
    }
    return null;
  }

}
