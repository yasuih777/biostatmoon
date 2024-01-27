# !/usr/bin/env python3

import matplotlib.pyplot as plt

from src.simulate.significant_test import generate, simulate, visualize

if __name__ == "__main__":
    test_info = {"method": "welch", "alternative": "greater", "alpha": 0.05}
    generators = {
        "x": generate.build_generator("norm", mu=0.5),
        "y": generate.build_generator("norm"),
    }

    simulator = simulate.build_simulator(
        "ttest", test_info=test_info, generators=generators, iters=1000
    )

    visualizer = visualize.Visualizer(simulator)

    simulator.execute("basic")
    visualizer.reset_simulator(simulator)

    fig, axes = visualizer.create_figure(nrows=1, ncols=1)
    visualizer.stat_density(axes)
    plt.show()
    plt.close()
