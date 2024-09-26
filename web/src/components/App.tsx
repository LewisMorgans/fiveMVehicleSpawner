import React, { useEffect, useState } from "react";
import { debugData } from "../utils/debugData";
import { fetchNui } from "../utils/fetchNui";
import { Box, Button, FormControl, FormGroup, InputLabel, MenuItem, Select, Stack, Typography } from "@mui/material";
import "./App.css";
import { SelectChangeEvent } from "@mui/material";

debugData([
    {
        action: "setVisible",
        data: true,
    },
]);

type VehicleDictionary = {
    [key: string]: {
        id: string;
        value: string;
    }[];
};

const App: React.FC = () => {
    const [selectedFaction, setSelectedFaction] = useState<string>("");
    const [vehicles, setVehicles] = useState<{ id: string; value: string }[]>([]);
    const [selectedVehicle, setSelectedVehicle] = useState("");
    const [vehicleFactions, setVehicleFactions] = useState<string[]>([]);
    const [vehicleList, setVehicleList] = useState<VehicleDictionary | null>(null);

    const handleFactionChange = (event: SelectChangeEvent) => {
        const faction = event.target.value;
        setSelectedFaction(faction);
        if (vehicleList && faction in vehicleList) {
            setVehicles(vehicleList[faction]);
        }
    };

    function setVehicleRequest(event: SelectChangeEvent) {
        const vehicle = event.target.value || "";
        setSelectedVehicle(vehicle);
    }

    const handleGetClientData = () => {
        fetchNui("spawnVehicle", selectedVehicle);
    };

    useEffect(() => {
        fetchNui<VehicleDictionary>("vehicleList").then((data) => {
            if (data && typeof data === "object") {
                setVehicleList(data);
                setVehicleFactions(Object.keys(data));
            }
        });
    }, []);

    return (
        <div className="nui-wrapper">
            <div className="nui-form">
                <Typography variant="h5" gutterBottom marginBottom={4}>
                    Vehicle Spawner
                </Typography>
                <FormGroup>
                    <Stack spacing={3}>
                        <FormControl fullWidth>
                            <InputLabel id="service-faction-label" sx={{ color: "#fff" }}>
                                Service Faction
                            </InputLabel>
                            <Select
                                labelId="service-faction-label"
                                id="service-faction"
                                value={selectedFaction}
                                label="Service"
                                sx={{ minWidth: 300, color: "#fff" }}
                                MenuProps={{
                                    PaperProps: {
                                        sx: {
                                            bgcolor: "#282c34",
                                            color: "white",
                                        },
                                    },
                                }}
                                onChange={handleFactionChange}
                            >
                                {vehicleFactions.map((factionName) => (
                                    <MenuItem key={factionName} value={factionName}>
                                        {factionName}
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>

                        <FormControl fullWidth>
                            <InputLabel id="select-vehicle-label" sx={{ color: "#fff" }}>
                                Select Vehicle
                            </InputLabel>
                            <Select
                                labelId="select-vehicle-label"
                                id="select-vehicle"
                                value={selectedVehicle}
                                label="Vehicle"
                                sx={{ minWidth: 300, color: "#fff" }}
                                MenuProps={{
                                    PaperProps: {
                                        sx: {
                                            bgcolor: "#282c34",
                                            color: "white",
                                        },
                                    },
                                }}
                                onChange={setVehicleRequest}
                            >
                                {vehicles.length > 0 ? (
                                    vehicles.map((vehicle, index) => (
                                        <MenuItem key={index} value={vehicle.id}>
                                            {vehicle.value}
                                        </MenuItem>
                                    ))
                                ) : (
                                    <MenuItem disabled>No vehicles available</MenuItem>
                                )}
                            </Select>
                        </FormControl>
                        <Box>
                            <Button variant="contained" fullWidth onClick={handleGetClientData}>
                                Spawn Vehicle
                            </Button>
                        </Box>
                    </Stack>
                </FormGroup>
            </div>
        </div>
    );
};

export default App;
