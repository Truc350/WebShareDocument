package vn.edu.hcmuaf.fit.websharedocument.controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.websharedocument.util.CloudinaryUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "CloudinarySignatureServlet", value = "/cloudinary/signature")
public class CloudinarySignatureServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long timestamp = System.currentTimeMillis() / 1000L;
        String publicId = "websharedoc_" + System.currentTimeMillis();
        
        Map<String, Object> paramsToSign = new HashMap<>();
        paramsToSign.put("timestamp", timestamp);
        paramsToSign.put("public_id", publicId);
        
        try {
            String apiSecret = CloudinaryUtil.getCloudinary().config.apiSecret;
            String apiKey = CloudinaryUtil.getCloudinary().config.apiKey;
            String cloudName = CloudinaryUtil.getCloudinary().config.cloudName;
            
            String signature = CloudinaryUtil.getCloudinary().apiSignRequest(paramsToSign, apiSecret);
            
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("signature", signature);
            responseData.put("timestamp", timestamp);
            responseData.put("apiKey", apiKey);
            responseData.put("cloudName", cloudName);
            responseData.put("publicId", publicId);
            
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(new Gson().toJson(responseData));
        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write("{\"error\": \"Error generating signature\"}");
        }
    }
}
