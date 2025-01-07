let project = new Project("New Project");

await project.addProject("submodules/s2D");

project.addSources("src");
project.addAssets("assets/**", {
    nameBaseDir: "assets",
    destination: "assets/{dir}/{name}",
    name: "{dir}/{name}",
});

// Compiler Flags
project.addDefine("S2D_DEBUG_FPS");
project.addDefine("S2D_RP_ENV_LIGHTING");
project.addDefine("S2D_PP");
project.addDefine("S2D_PP_DOF");
project.addDefine("S2D_PP_DOF_QUALITY 1");
project.addDefine("S2D_PP_MIST");
project.addDefine("S2D_PP_FISHEYE");
project.addDefine("S2D_PP_FILTER");
project.addDefine("S2D_PP_COMPOSITOR");

resolve(project);
