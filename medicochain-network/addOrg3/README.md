## Adding Wholesaler to the test network

You can use the `addWholesaler.sh` script to add another organization to the Fabric test network. The `addWholesaler.sh` script generates the Wholesaler crypto material, creates an Wholesaler organization definition, and adds Wholesaler to a channel on the test network.

You first need to run `./network.sh up createChannel` in the `medicochain-network` directory before you can run the `addWholesaler.sh` script.

```
./network.sh up createChannel
cd addWholesaler
./addWholesaler.sh up
```

If you used `network.sh` to create a channel other than the default `medicochainchannel`, you need pass that name to the `addwholesaler.sh` script.
```
./network.sh up createChannel -c channel1
cd addWholesaler
./addWholesaler.sh up -c channel1
```

You can also re-run the `addWholesaler.sh` script to add Wholesaler to additional channels.
```
cd ..
./network.sh createChannel -c channel2
cd addWholesaler
./addWholesaler.sh up -c channel2
```

For more information, use `./addWholesaler.sh -h` to see the `addWholesaler.sh` help text.
