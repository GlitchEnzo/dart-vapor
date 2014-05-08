library vapor;

import 'dart:collection';
import 'dart:html';
import 'dart:math' as Math;
import 'dart:typed_data';
import 'dart:web_audio';
import 'dart:web_gl' as WebGL;

import 'package:box2d/box2d.dart' as Box2D;
import 'package:vector_math/vector_math.dart';

// export the vector_math package in order to get Vectors, Matrices, Quaternions, etc defined automatically
export 'package:vector_math/vector_math.dart';

// export the Dart HTML package in order to get KeyCodes defined automatically
export 'dart:html';

part 'audio/audio.dart';

part 'game/component.dart';
part 'game/game_object.dart';
part 'game/scene.dart';

part 'graphics/camera.dart';
part 'graphics/canvas.dart';
part 'graphics/color.dart';
part 'graphics/material.dart';
part 'graphics/mesh.dart';
part 'graphics/mesh_renderer.dart';
part 'graphics/renderer.dart';
part 'graphics/shader.dart';
part 'graphics/shader_type.dart';
part 'graphics/texture2d.dart';

part 'input/keyboard.dart';
part 'input/mouse.dart';
part 'input/touch.dart';
part 'input/touch_data.dart';
part 'input/touch_phase.dart';

part 'math/transform.dart';

part 'physics/box_collider.dart';
part 'physics/circle_collider.dart';
part 'physics/collider.dart';
part 'physics/revolute_joint.dart';
part 'physics/rigid_body.dart';

part 'utilities/file_downloader.dart';
part 'utilities/time.dart';

/**
 * The global handle to the current instance of the WebGL rendering context.
 */
WebGL.RenderingContext gl;