#ifndef RENDER_H
#define RENDER_H

#define GLAD_GL_IMPLEMENTATION

#include "ui/glad.h"
#include "hlprs/extra.h"
#define GLFW_INCLUDE_NONE
#include <GLFW/glfw3.h>

#include "linmath.h"
#include <stdlib.h>
#include <stddef.h>
#include <stdio.h>

#include "engine/game.h"
#include "hlprs/extra.h"

void startRender(void);

#endif