#include <Halide/Halide.h>

namespace {

class RDomInput : public Halide::Generator<RDomInput> {
public:
	Input<Halide::Buffer<uint8_t>>  input{"input", 2};
	Output<Halide::Buffer<uint8_t>> output{"output", 2};

    void generate() {
		Halide::RDom r(input);

        // Note: this is terrible way to process all the pixels
        // in an image: do not imitate this code. It exists solely
        // to verify that RDom() accepts an Input<Buffer<>> as well a
        // plain Buffer<>.
		Halide::Var x, y;
        output(x, y) = Halide::cast<uint8_t>(0);
        output(r.x, r.y) += input(r.x, r.y) ^ Halide::cast<uint8_t>(0xff);

		Halide::RDom r2(output);  // unused, just here to ensure it compiles
    }
};

}  // namespace

HALIDE_REGISTER_GENERATOR(RDomInput, rdom_input)
