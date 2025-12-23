package com.wyu.studyonline.pojo;

import java.util.Date;

public class UserProfile {
    private int id;
    private int userId;
    private Date birthday;
    private String school;
    private String major;
    private String hometown;
    private String signature;
    private Date updateTime;

    public UserProfile() {
    }

    public UserProfile(int userId, Date birthday, String school, String major, String hometown, String signature) {
        this.userId = userId;
        this.birthday = birthday;
        this.school = school;
        this.major = major;
        this.hometown = hometown;
        this.signature = signature;
        this.updateTime = new Date();
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

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public String getSchool() {
        return school;
    }

    public void setSchool(String school) {
        this.school = school;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public String getHometown() {
        return hometown;
    }

    public void setHometown(String hometown) {
        this.hometown = hometown;
    }

    public String getSignature() {
        return signature;
    }

    public void setSignature(String signature) {
        this.signature = signature;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "UserProfile{" +
                "id=" + id +
                ", userId=" + userId +
                ", birthday=" + birthday +
                ", school='" + school + '\'' +
                ", major='" + major + '\'' +
                ", hometown='" + hometown + '\'' +
                ", signature='" + signature + '\'' +
                ", updateTime=" + updateTime +
                '}';
    }
}