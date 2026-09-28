///|
/// The message emitter used by every interactive component. Aliased from
/// the rendering framework so components and callers speak in `@sumi`
/// terms while staying fully interchangeable with the underlying type.
pub type Emit[Msg] = @rabbita.Emit[Msg]

///|
/// A live value in the incremental rendering graph, re-exported for
/// components that return one.
pub type Live[T] = @rabbita.Val[T]
