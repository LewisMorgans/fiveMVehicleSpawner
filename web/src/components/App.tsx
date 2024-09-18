import React, { useState } from "react";
import "./App.css";
import { debugData } from "../utils/debugData";
import { fetchNui } from "../utils/fetchNui";
import { Box, Button, FormControl, FormGroup, InputLabel, MenuItem, Select, SelectChangeEvent, Stack, Typography } from "@mui/material";
import vehicleList from '../assets/vehicleList.json'

debugData([
    {
        action: "setVisible",
        data: true,
    },
]);

const App: React.FC = () => {
    const [selectedFaction, setSelectedFaction] = useState<keyof typeof vehicleList | ''>('');
    const [vehicles, setVehicles] = useState<string[]>([]);
    const [selectedVehicle, setSelectedVehicle] = useState("")

    const handleFactionChange = (event: React.ChangeEvent<{ value: unknown }>) => {
        const faction = event.target.value as keyof typeof vehicleList;
        setSelectedFaction(faction);
        setVehicles(vehicleList[faction] || []);
    };

    function setVehicleRequest(event: React.ChangeEvent<{ value: unknown }>) {
        const vehicle = event?.target.value as string || "";
        setSelectedVehicle(vehicle);
    }

    const handleGetClientData = () => {
        fetchNui("spawnVehicle", selectedVehicle)
    };

    return (
        <div className="nui-wrapper">
            <div className="popup-thing">
                <Typography variant="h5" gutterBottom marginBottom={4}>Vehicle Spawner</Typography>
                <FormGroup className="VehicleSpawnForm">
                    <Stack spacing={3}>
                        <FormControl fullWidth>
                            <InputLabel id="service-faction-label" sx={{ color: "#fff" }}>Service Faction</InputLabel>
                            <Select
                                labelId="service-faction-label"
                                id="service-faction"
                                value={selectedFaction}
                                label="Service"
                                sx={{ minWidth: 300, color: "#fff" }}
                                MenuProps={{
                                    PaperProps: {
                                        sx: {
                                            bgcolor: '#282c34',
                                            color: 'white',
                                        },
                                    },
                                }}
                                // @ts-ignore
                                onChange={handleFactionChange}
                            >
                                <MenuItem value={"BCSO"}>Blaine County Sheriff Office</MenuItem>
                                <MenuItem value={"LSPD"}>Los Santos Police Department</MenuItem>
                                <MenuItem value={"SAST"}>San Andreas State Troopers</MenuItem>
                                <MenuItem value={"SAFD"}>San Andreas Fire Department</MenuItem>
                            </Select>
                        </FormControl>

                        <FormControl fullWidth>
                            <InputLabel id="select-vehicle-label" sx={{ color: "#fff" }}>Select Vehicle</InputLabel>
                            <Select
                                labelId="select-vehicle-label"
                                id="select-vehicle"
                                label="Vehicle"
                                sx={{ minWidth: 300, color: "#fff" }}
                                MenuProps={{
                                    PaperProps: {
                                        sx: {
                                            bgcolor: '#282c34',
                                            color: 'white',
                                        },
                                    },
                                }}
                                // @ts-ignore
                                onChange={setVehicleRequest}
                            >
                                {vehicles.map((vehicle, index) => (
                                    <MenuItem key={index} value={vehicle} >{vehicle}</MenuItem>
                                ))}
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
