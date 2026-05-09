package vn.edu.hcmuaf.fit.websharedocument.model;

import java.time.LocalDateTime;

public class Document {

    private int id;
    private int userId;
    private Integer categoryId;

    private String title;
    private String description;

    private String fileName;
    private String filePath;

    private long fileSize;

    private String fileType;
    private String fileExtension;

    private int downloadCount;
    private int viewCount;

    private int isActive;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private String uploaderName;
    private String categoryName;

    public Document() {
        this.isActive = 0;
    }

    public Document(int id,
                    int userId,
                    Integer categoryId,
                    String title,
                    String description,
                    String fileName,
                    String filePath,
                    long fileSize,
                    String fileType,
                    String fileExtension,
                    int downloadCount,
                    int viewCount,
                    int isActive,
                    LocalDateTime createdAt,
                    LocalDateTime updatedAt,
                    String uploaderName,
                    String categoryName) {

        this.id = id;
        this.userId = userId;
        this.categoryId = categoryId;
        this.title = title;
        this.description = description;
        this.fileName = fileName;
        this.filePath = filePath;
        this.fileSize = fileSize;
        this.fileType = fileType;
        this.fileExtension = fileExtension;
        this.downloadCount = downloadCount;
        this.viewCount = viewCount;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.uploaderName = uploaderName;
        this.categoryName = categoryName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }


    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }


    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }


    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }


    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }


    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }


    public long getFileSize() {
        return fileSize;
    }

    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }


    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }


    public String getFileExtension() {
        return fileExtension;
    }

    public void setFileExtension(String fileExtension) {
        this.fileExtension = fileExtension;
    }


    public int getDownloadCount() {
        return downloadCount;
    }

    public void setDownloadCount(int downloadCount) {
        this.downloadCount = downloadCount;
    }


    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }


    public int getIsActive() {
        return isActive;
    }

    public void setIsActive(int active) {
        this.isActive = isActive;
    }


    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }


    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }


    public String getUploaderName() {
        return uploaderName;
    }

    public void setUploaderName(String uploaderName) {
        this.uploaderName = uploaderName;
    }


    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

}