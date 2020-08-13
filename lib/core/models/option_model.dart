class OptionsModel<T> {
    String imageAsset;
    String name;
    T value;
    bool isSelected;

    OptionsModel({
        this.imageAsset,
        this.name,
        this.value
    });
    
    OptionsModel.withSelected({
        this.imageAsset,
        this.name,
        this.value,
        this.isSelected
    });
}
