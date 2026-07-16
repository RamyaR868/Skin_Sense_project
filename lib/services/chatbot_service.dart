class ChatbotService {
  static String getResponse(String query) {
    String input = query.toLowerCase();

    // Greeting logic
    if (input.contains("hello") ||
        input.contains("hi") ||
        input.contains("hey")) {
      return "Hello! I'm your SkinSense Assistant. How can I help you with your skin health today?";
    }

    // Melanoma logic
    else if (input.contains("melanoma")) {
      return "Melanoma is the most dangerous form of skin cancer. It often resembles moles; some develop from moles. Look for the ABCDEs: Asymmetry, Border, Color, Diameter, and Evolving.";
    }

    // BCC (Basal Cell Carcinoma) logic
    else if (input.contains("bcc") || input.contains("basal cell")) {
      return "Basal Cell Carcinoma (BCC) is the most common form of skin cancer. It usually grows slowly and rarely spreads, appearing as a pearly bump or a pinkish patch of skin. Early detection is key!";
    }

    // "None" / Benign logic
    else if (input.contains("none") ||
        input.contains("no cancer") ||
        input.contains("benign") ||
        input.contains("clear")) {
      return "That's great news! A 'None' or 'Benign' result means no immediate signs of malignancy were detected. However, continue to monitor your skin regularly for any changes.";
    }

    // Sunscreen & Prevention
    else if (input.contains("sunscreen") ||
        input.contains("protection") ||
        input.contains("spf")) {
      return "Daily use of SPF 30 or higher reduces the risk of squamous cell carcinoma by about 40% and melanoma by 50%. Don't forget to reapply every 2 hours!";
    }

    // Gratitude
    else if (input.contains("thank")) {
      return "You're very welcome! Stay safe and keep an eye on your skin.";
    }

    // Default Fallback
    else {
      return "I'm still learning about specific cases. If you're worried about a specific spot, please use the 'Start Scan' feature on the Home Screen or visit a dermatologist.";
    }
  }
}
