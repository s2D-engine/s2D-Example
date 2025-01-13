let project = new Project("New Project");

project.addSources("src");
project.addAssets("assets/**", {
    nameBaseDir: "assets",
    destination: "assets/{dir}/{name}",
    name: "{dir}/{name}",
});

// s2D Compiler Flags
process.defines = [
    "S2D_DEBUG_FPS",
    "S2D_RP_ENV_LIGHTING",
    // "S2D_PP_DOF",
    // "S2D_PP_DOF_QUALITY 1",
    // "S2D_PP_MIST",
    // "S2D_PP_FISHEYE",
    "S2D_PP_FILTER",
    "S2D_PP_COMPOSITOR",
];
await project.addProject("s2D");

resolve(project);
