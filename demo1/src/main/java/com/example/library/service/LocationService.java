package com.example.library.service;

import com.example.library.entity.Location;
import java.util.List;

public interface LocationService {

    Location getById(Integer id);

    Location getByCode(String code);

    List<Location> getAll();

    List<String> getAllLibraries();

    List<Location> getByLibrary(String libraryName);

    boolean add(Location location);

    boolean update(Location location);

    boolean updateStatus(Integer id, Integer status);

    boolean delete(Integer id);
}