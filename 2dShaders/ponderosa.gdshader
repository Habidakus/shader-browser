shader_type canvas_item;

uniform float grid_size = 10.0;
uniform float speed = 4.0;
uniform int layers = 10;

uniform sampler3D x_sampler : repeat_enable;
uniform sampler3D y_sampler : repeat_enable;


int get_square(vec2 coord, float our_index_x, float our_index_y, float t)
{
    float weight = abs(sin(TIME * speed));
    weight *= weight;
    float min_diff = 100.0;
    int ret_val = 0;
    for (int dx = -2; dx <= 2; ++dx)
    {
        float cell_x = (our_index_x + float(dx)) / grid_size;
        for (int dy = -2; dy <= 2; ++dy)
        {
            float cell_y = (our_index_y + float(dy)) / grid_size;
            vec3 point_vec = vec3(cell_x, cell_y, t);
            vec3 weight_vec = vec3(cell_x, cell_y, weight);
            float cell_weight = texture(x_sampler, weight_vec).r;
            float cell_offset_x = texture(x_sampler, point_vec).r * 3.0 - 1.0;
            float cell_offset_y = texture(y_sampler, point_vec).r * 3.0 - 1.0;
            float cell_point_loc_x = cell_x + cell_offset_x / grid_size;
            float cell_point_loc_y = cell_y + cell_offset_y / grid_size;
            float diff_x = coord.x - cell_point_loc_x;
            float diff_y = coord.y - cell_point_loc_y;
            float diff = (diff_x * diff_x + diff_y * diff_y) * cell_weight;
            if (diff < min_diff)
            {
                min_diff = diff;
                ret_val = dx * 7 + dy;
            }
        }
    }

    return ret_val;
}

float get_value(vec2 coord)
{
    float t = 0.1 + (sin(TIME) + 1.0) * speed;
    // Called for every pixel the material is visible on.
    vec2 our_cell = coord * grid_size;
    float our_index_x = floor(our_cell.x);
    float our_index_y = floor(our_cell.y);

    float range_start = 0.1;
    float range_end = 0.9;

    float pl = range_start;
    float dl = range_end;
    int start_square = get_square(coord, our_index_x, our_index_y, pl);
    float value = 1.0;
    for (int i = 0; i < layers; ++i)
    {
        dl = range_start + (range_end - range_start) * float(1 + i) / float(layers);
        int next_square = get_square(coord, our_index_x, our_index_y, dl);
        if (next_square != start_square)
        {
            break;
        }

        pl = dl;
    }

    if (pl != dl)
    {
        float bl = pl;
        float ul = dl;
        for (int j = 0; j < layers; ++j)
        {
            ul = pl + (dl - pl) * float(1 + j) / float(layers);
            int next_square = get_square(coord, our_index_x, our_index_y, ul);
            if (next_square != start_square)
            {
                break;
            }

            bl = ul;
        }

        if (bl == ul)
        {
            pl = pl + (dl - pl) * float(layers - 1) / float(layers);
            dl = ul;
        }
        else
        {
            pl = bl;
            dl = ul;
        }
    }

    if (pl != dl)
    {
        float bl = pl;
        float ul = dl;
        for (int j = 0; j < layers; ++j)
        {
            ul = pl + (dl - pl) * float(1 + j) / float(layers);
            int next_square = get_square(coord, our_index_x, our_index_y, ul);
            if (next_square != start_square)
            {
                break;
            }

            bl = ul;
        }

        if (bl == ul)
        {
            pl = pl + (dl - pl) * float(layers - 1) / float(layers);
            dl = ul;
        }
        else
        {
            pl = bl;
            dl = ul;
        }
    }

    return (pl + dl) / 2.0;
}

void fragment() {
    float value = get_value(UV);
    COLOR.rgba = vec4(value, value, value, 1.0);
}
