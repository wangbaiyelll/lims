package com.example.library.entity;

import lombok.Data;

@Data
public class Role {
    private Integer id;
    private String roleName;
    private String permissionJson;
}
